import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:careerguide_ai/services/api_service.dart';

void main() {
  group('Integration Tests - App Connectivity', () {
    test('Check Backend Connection', () async {
      final api = ApiService();
      try {
        // Simple ping to backend
        final response = await http.get(Uri.parse('${api.baseUrl}/'));
        expect(response.statusCode, 200);
      } catch (e) {
        fail('Le backend n\'est pas accessible. Assurez-vous que FastAPI est lancé.');
      }
    });

    test('Test Auth Flow API', () async {
      final api = ApiService();
      try {
        final user = await api.identifyUser('00000000', 'Test', 'User', 20);
        expect(user['phone'], '00000000');
        expect(user, contains('id'));
      } catch (e) {
        fail('Erreur lors de l\'identification API: $e');
      }
    });

    test('Test Chat API', () async {
      final api = ApiService();
      try {
        final reply = await api.sendMessage('Comment choisir mon école ?', 'Technologie');
        expect(reply, contains('reply'));
      } catch (e) {
        fail('Erreur lors de la communication avec l\'IA: $e');
      }
    });
  });
}
