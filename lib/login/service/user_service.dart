import 'dart:convert';

import 'package:riverbank_pretotype_mobile/common/env.dart';
import 'package:riverbank_pretotype_mobile/logger/logger.dart';
import 'package:riverbank_pretotype_mobile/login/model/user.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserServiceFactory {
  UserService createUserServiceInstance() {
    if (devMode) {
      return DevUserServiceImpl();
    }

    return UserServiceImpl();
  }
}

abstract class UserService {
  Future<User?> get(String id);
  Future<User?> getByPreference();
}

class UserServiceImpl implements UserService {
  @override
  Future<User?> get(String id) async {
    logger.d('id: $id');
    var uri = Uri.parse('https://api-dev.riverbank.world/v1/user/$id');
    final response = await http.get(uri);
    final json = jsonDecode(response.body);

    return User(id: json['id'], name: json['name'], profileImageUrl: json['profileImageUrl'], provider: json['provider'], email: json['email']);
  }

  @override
  Future<User?> getByPreference() async {
    logger.d('getByPreference');
    final preference = await SharedPreferences.getInstance();
    final userId = preference.getString('user_id');
    if (userId == null) {
      return null;
    }

    return await get(userId);
  }
}

class DevUserServiceImpl implements UserService {
  @override
  Future<User?> get(String id) async {
    logger.d('id: $id');
    var uri = Uri.parse('https://api-dev.riverbank.world/v1/user?userId=$id');
    final response = await http.get(uri);
    final json = jsonDecode(response.body);
    if (json.length == 0) {
      return null;
    }

    return User(id: json['id'], name: json['name'], profileImageUrl: json['profileImageUrl'], provider: json['provider'], email: json['email']);
  }

  @override
  Future<User?> getByPreference() async {
    logger.d('getByPreference');
    final preference = await SharedPreferences.getInstance();
    final userId = preference.getString('user_id');
    if (userId == null) {
      return null;
    }

    final user = await get(userId);
    if (user == null) {
      return null;
    }

    return user;
  }
}