import 'dart:convert';

import 'package:http/http.dart' as http;

class JoinService {
  Future<void> signUp(String name, String email, String provider, String? photoUrl) async {
    final postUserUri = Uri.parse('https://api-dev.riverbank.world/v1/user');
    final postUserResponse = await http.post(postUserUri, headers: {
      'Content-Type': 'application/json'
    }, body: jsonEncode({
      'name': name,
      'email': email,
      'provider': provider,
      'profile_image_url': photoUrl,
    }));
  }
}