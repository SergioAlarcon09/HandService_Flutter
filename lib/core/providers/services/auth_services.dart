import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.4:3001/api/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['token'];
    } else {
      return null;
    }
  }

  Future<String?> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.4:3001/api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.startsWith('{')) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['token'];
      } else {
        return 'User registered';
      }
    } else {
      return null;
    }
  }
}
