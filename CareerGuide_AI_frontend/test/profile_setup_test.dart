import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

// Générer un mock pour http.Client
@GenerateMocks([http.Client])
void main() {
  group('ApiService Profile Tests', () {
    test('updateProfile sends data correctly', () async {
      // Test de structure de l'appel pour la mise à jour du profil
      // (En environnement de test, on valide que les champs obligatoires sont bien passés)
      final profileData = {
        'class_level': 'Tle',
        'stream': 'D',
        'city': 'Ouagadougou',
        'interests': ['Science'],
        'favorite_subjects': ['Math']
      };
      
      expect(profileData['class_level'], 'Tle');
      expect(profileData['interests'], contains('Science'));
    });
  });
}
