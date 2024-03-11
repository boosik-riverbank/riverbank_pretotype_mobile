import 'dart:convert';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;

import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverbank_pretotype_mobile/common/error.dart';
import 'package:riverbank_pretotype_mobile/logger/logger.dart';
import 'package:riverbank_pretotype_mobile/login/exception/not_signed_in_exception.dart';
import 'package:riverbank_pretotype_mobile/login/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static const _keyUserId = 'user_id';
  GoogleSignIn? googleSignIn;

  LoginService() {
    final List<String> scopes = <String>[
      'email',
    ];
    googleSignIn = GoogleSignIn(
      scopes: scopes,
    );
  }

  Future<bool> isSignedIn() async {
    final preference = await SharedPreferences.getInstance();
    final userId = preference.getString(_keyUserId);
    final userIdQueryUri = Uri.parse('https://api-dev.riverbank.world/v1/user?userId=$userId');
    final userIdQueryResponse = await http.get(userIdQueryUri, headers: {
      'Content-Type': 'application/json'
    });
    final jsonData = jsonDecode(userIdQueryResponse.body);
    return userId != null && jsonData.length > 0;
  }

  Future<bool> isSignedUp(String email, String provider) async {
    switch (provider) {
      case 'google':
        final isSignedIn = await googleSignIn?.isSignedIn() ?? false;
        if (isSignedIn) {
          break;
        } else {
          logger.e('This user is not signed in. provider: google');
          throw NotSignedInException();
        }
        break;
      case 'facebook':
        final LoginResult result = await FacebookAuth.instance.login(permissions: ['public_profile', 'email']);
        if (result.status == LoginStatus.failed) {
          logger.e('This user is not signed in. provider: facebook');
          throw NotSignedInException();
        }
        break;
    }

    final emailQueryUri = Uri.parse('https://api-dev.riverbank.world/v1/user?email=$email');
    final emailQueryResponse = await http.get(emailQueryUri, headers: {
      'Content-Type': 'application/json'
    });
    final jsonData = jsonDecode(emailQueryResponse.body);
    logger.d('LoginService isSignedUp? (email: $email) : $jsonData}');
    if (jsonData['message'] == 'Cannot find user') {
      return false;
    }

    return true;
  }

  Future<User> handleGoogleSignIn() async {
    logger.i('handleGoogleSignIn()');
    final account = await googleSignIn?.signIn();
    logger.d('google account: ${account.toString()}');
    if (account == null) {
      throw NotSignedInException();
    }

    final isSignedUp = await this.isSignedUp(account.email, 'google');
    if (!isSignedUp) {
      // sign up
      logger.d('This user need to sign up');
      final postUserUri = Uri.parse('https://api-dev.riverbank.world/v1/user');
      final postUserResponse = await http.post(postUserUri, headers: {
        'Content-Type': 'application/json'
      }, body: jsonEncode({
        'name': account.displayName,
        'email': account.email,
        'provider': 'google',
        'profile_image_url': account.photoUrl,
      }));

      if (postUserResponse.statusCode == 500) {
        if (postUserResponse.body.contains('duplicate key value')) {
          throw DuplicateEmailException(account?.email ?? '');
        }
      }

      final json = jsonDecode(postUserResponse.body);
      return User.fromJson(json);
    } else {
      // already sign up
      logger.d('This user is already member');
      var uri = Uri.parse('https://api-dev.riverbank.world/v1/user?email=${account?.email ?? ''}');
      final response = await http.get(uri);
      final json = jsonDecode(response.body);

      return User.fromJson(json);
    }
  }

  Future<User> handleFacebookSignIn() async {
    logger.i('handleFacebookSignIn()');
    final LoginResult result = await FacebookAuth.instance.login(permissions: ['public_profile', 'email']);
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken accessToken = result.accessToken!;
      final user = await FacebookAuth.instance.getUserData(fields: "name,email,picture.width(200)");
      logger.d('user: $user');
      final isSignedUp = await this.isSignedUp(user['email'], 'facebook');
      if (!isSignedUp) {
        // need to sign up
        final postUserUri = Uri.parse('https://api-dev.riverbank.world/v1/user');
        final postUserResponse = await http.post(postUserUri, headers: {
          'Content-Type': 'application/json'
        }, body: jsonEncode({
          'name': user['name'],
          'email': user['email'],
          'provider': 'facebook',
          'profile_image_url': user['picture']['data']['url'],
        }));

        if (postUserResponse.statusCode == 500) {
          if (postUserResponse.body.contains('duplicate key value')) {
            throw DuplicateEmailException(user['email'] ?? '');
          }
        }

        final json = jsonDecode(postUserResponse.body);

        return User.fromJson(json);
      } else {
        // already sign up
        var uri = Uri.parse('https://api-dev.riverbank.world/v1/user?email=${user['email'] ?? ''}');
        final response = await http.get(uri);
        final json = jsonDecode(response.body);

        return User.fromJson(json[0]);
      }
    } else {
      throw Error();
    }
  }

  Future<void> saveUserToPreference(String userId) async {
    logger.i('save user to preference : $userId');
    final preference = await SharedPreferences.getInstance();
    preference.setString(_keyUserId, userId);
  }
}