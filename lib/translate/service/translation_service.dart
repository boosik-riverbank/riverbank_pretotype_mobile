import 'dart:convert';

import 'package:http/http.dart' as http;

class TranslationService {
  Future<String> translate(String targetLanguage, String text) async {
    var uri = Uri.parse('https://api-dev.riverbank.world/v1/translation');
    var response = await http.post(uri, headers: {
      'Content-Type': 'application/json'
    }, body: jsonEncode({
      "text": text,
      "target_language": "korean"
    }));

    var json =  jsonDecode(utf8.decode(response.bodyBytes));
    return json["translated_message"];
  }
}