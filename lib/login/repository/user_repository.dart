import 'package:riverbank_pretotype_mobile/login/model/user.dart';
import 'package:riverbank_pretotype_mobile/login/service/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  UserRepository._privateConstructor();

  static final UserRepository _instance = UserRepository._privateConstructor();

  factory UserRepository() {
    return _instance;
  }

  UserService userService = UserServiceFactory().createUserServiceInstance();
  User? _user;
  String? _id;
  bool isInitialized = false;

  Future<void> init(String id) async {
    _id = id;
    _user = await userService.get(id);
    isInitialized = true;
  }

  Future<User?> get() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    if (userId != null) {
      final user = await userService.get(userId);
      if (user != null) {
        prefs.setString('user_id', user.id);
        _user = user;
      } else {
        return null;
      }
    }

    return _user;
  }

  User? getSavedUser() {
    return _user;
  }

  String getId() {
    return _id!;
  }
}