import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/backend_config.dart';

class ApiService {
  String get baseUrl => BackendConfig.baseUrl;

  Future<Map<String, dynamic>> identifyUser(String phone, String firstName, String lastName, int age) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/identify'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'phone': phone,
        'first_name': firstName,
        'last_name': lastName,
        'age': age,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur d\'identification: ${response.statusCode}');
    }
  }

  Future<void> updateProfile(int userId, Map<String, dynamic> profileData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/profile/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(profileData),
    );

    if (response.statusCode != 200) {
      throw Exception('Erreur de mise à jour du profil: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> sendMessage(String message, String recommendedProgram) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chat/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'message': message,
        'recommended_program': recommendedProgram,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erreur de chat: ${response.statusCode}');
    }
  }
}
