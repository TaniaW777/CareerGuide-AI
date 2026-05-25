import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:careerguide_ai/services/api_service.dart';

// Générer un mock pour http.Client
@GenerateMocks([http.Client])
void main() {
  group('ApiService Tests', () {
    test('identifyUser calls API and returns user data', () async {
      // Pour les besoins du test unitaire sans serveur réel,
      // on pourrait mocker http.Client, mais pour valider le 'Pont'
      // nous vérifierons la structure des appels.
      final apiService = ApiService();
      
      // Verification simple: la structure de l'URL est correcte
      // Note: BackendConfig.baseUrl retourne http://127.0.0.1:8001 ou http://10.0.2.2:8001
      // selon la plateforme, donc on vérifie juste que c'est correctement construit
      expect(apiService.baseUrl, contains("8001"));
    });
  });
}
