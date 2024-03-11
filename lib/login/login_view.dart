import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:http/http.dart' as http;
import 'package:riverbank_pretotype_mobile/common/error.dart';
import 'package:riverbank_pretotype_mobile/login/repository/user_repository.dart';
import 'package:riverbank_pretotype_mobile/login/service/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignIn? googleSignIn;

  Future<void> _handleSignIn() async {
    try {
      final user = await LoginService().handleGoogleSignIn();
      await LoginService().saveUserToPreference(user.id);
      await UserRepository().init(user.id);
      context.go('/balance');
    } catch (error) {
      if (error is DuplicateEmailException) {
        print('duplicated key error!!!');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 96, bottom: 96),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Image.asset('asset/image/splash_logo.png')
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff3629B7),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: CupertinoButton(
                    onPressed: () async {
                      try {
                        final user = await LoginService().handleGoogleSignIn();
                        await LoginService().saveUserToPreference(user.id);
                        await UserRepository().init(user.id);
                        context.go('/balance');
                      } catch (error) {
                        if (error is DuplicateEmailException) {
                          print('duplicated key error!!!');
                        }
                      }
                    },
                    child: Center(
                      child: Text('Google Login', style: const TextStyle(color: Colors.white),)
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff3629B7),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: CupertinoButton(
                    onPressed: () async {
                      try {
                        final user = await LoginService().handleFacebookSignIn();
                        await LoginService().saveUserToPreference(user.id);
                        await UserRepository().init(user.id);
                        context.go('/balance');
                      } catch (error) {
                        if (error is DuplicateEmailException) {
                          print('duplicated key error!!!');
                        }
                      }
                    },
                    child: Center(
                        child: Text('Facebook Login', style: const TextStyle(color: Colors.white),)
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xff3629B7),
                      borderRadius: BorderRadius.circular(20)
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      _handleSignIn();
                    },
                    child: Center(
                        child: Text('Wechat Login', style: const TextStyle(color: Colors.white),)
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      )
    );
  }
}