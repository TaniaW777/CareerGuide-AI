import 'package:connectivity_plus/connectivity_plus.dart';

/// Service de gestion de la connectivité réseau
/// Détecte si l'appareil est connecté à internet
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  
  factory ConnectivityService() {
    return _instance;
  }
  
  ConnectivityService._internal();
  
  final Connectivity _connectivity = Connectivity();
  bool _isConnected = false;
  
  /// Getter pour vérifier l'état de la connexion
  bool get isConnected => _isConnected;
  
  /// Initialiser le service et commencer à écouter les changements
  Future<void> initialize() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _isConnected = _isConnectedFromResults(results);
      print('🌐 Connectivité initialisée: ${_isConnected ? "CONNECTÉ" : "DÉCONNECTÉ"}');
      
      // Écouter les changements de connectivité
      _connectivity.onConnectivityChanged.listen((results) {
        final wasConnected = _isConnected;
        _isConnected = _isConnectedFromResults(results);
        
        if (!wasConnected && _isConnected) {
          print('✅ Connexion rétablie! Passage en mode ONLINE');
        } else if (wasConnected && !_isConnected) {
          print('⚠️ Connexion perdue! Passage en mode OFFLINE');
        }
      });
    } catch (e) {
      print('❌ Erreur initialisation connectivité: $e');
      _isConnected = false;
    }
  }
  
  /// Convertir le résultat List<ConnectivityResult> en booléen
  bool _isConnectedFromResults(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
