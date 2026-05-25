import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/config/backend_config.dart';

/// Service de gestion de la connectivité réseau
/// Détecte si l'appareil est connecté à internet et au backend
class ConnectivityService extends ChangeNotifier {
  static final ConnectivityService _instance = ConnectivityService._internal();
  
  factory ConnectivityService() {
    return _instance;
  }
  
  ConnectivityService._internal();
  
  final Connectivity _connectivity = Connectivity();
  bool _isNetworkConnected = false;
  bool _isBackendOnline = false;
  bool _isGemmaReady = false;
  String _modeIndicator = '🔴 OFFLINE';
  
  /// Getters pour vérifier l'état de la connexion
  bool get isNetworkConnected => _isNetworkConnected;
  bool get isBackendOnline => _isBackendOnline;
  bool get isGemmaReady => _isGemmaReady;
  String get modeIndicator => _modeIndicator;
  bool get isFullyOnline => _isBackendOnline && _isGemmaReady;
  
  /// Initialiser le service et commencer à écouter les changements
  Future<void> initialize() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _isNetworkConnected = _isConnectedFromResults(results);
      debugPrint('🌐 Connectivité initialisée: ${_isNetworkConnected ? "CONNECTÉ" : "DÉCONNECTÉ"}');
      
      // Vérifier la connexion au backend
      await checkBackendConnection();
      
      // Écouter les changements de connectivité
      _connectivity.onConnectivityChanged.listen((results) async {
        final wasConnected = _isNetworkConnected;
        _isNetworkConnected = _isConnectedFromResults(results);
        
        if (!wasConnected && _isNetworkConnected) {
          debugPrint('✅ Connexion réseau rétablie!');
          await checkBackendConnection();
        } else if (wasConnected && !_isNetworkConnected) {
          debugPrint('⚠️ Connexion réseau perdue!');
          _isBackendOnline = false;
          _isGemmaReady = false;
          _updateModeIndicator();
          notifyListeners();
        }
      });
      
      // Vérifier périodiquement le backend (toutes les 30 secondes)
      _schedulePeriodicCheck();
    } catch (e) {
      debugPrint('❌ Erreur initialisation connectivité: $e');
      _isNetworkConnected = false;
      _isBackendOnline = false;
      _updateModeIndicator();
    }
  }
  
  /// Vérifier la connexion au backend et l'état de Gemma
  Future<void> checkBackendConnection() async {
    if (!_isNetworkConnected) {
      _isBackendOnline = false;
      _isGemmaReady = false;
      _updateModeIndicator();
      return;
    }

    try {
      final uri = BackendConfig.modelStatusUri();
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _isBackendOnline = true;
        _isGemmaReady = data['gemma_ready'] == true;
        debugPrint('✅ Backend connecté. Gemma: ${_isGemmaReady ? "PRÊT" : "CHARGEMENT"}');
      } else {
        _isBackendOnline = false;
        _isGemmaReady = false;
      }
    } catch (e) {
      _isBackendOnline = false;
      _isGemmaReady = false;
      debugPrint('⚠️ Backend indisponible: $e');
    }
    _updateModeIndicator();
    notifyListeners();
  }
  
  /// Planifier une vérification périodique du backend
  void _schedulePeriodicCheck() {
    Future.delayed(const Duration(seconds: 30), () {
      checkBackendConnection().then((_) {
        _schedulePeriodicCheck();
      }).catchError((e) {
        debugPrint('Erreur vérification: $e');
        _schedulePeriodicCheck();
      });
    });
  }
  
  /// Met à jour l'indicateur de mode (Online/Offline)
  void _updateModeIndicator() {
    if (_isBackendOnline && _isGemmaReady) {
      _modeIndicator = '🟢 ONLINE (Gemma Prêt)';
    } else if (_isBackendOnline) {
      _modeIndicator = '🟡 ONLINE (Chargement...)';
    } else {
      _modeIndicator = '🔴 OFFLINE';
    }
  }
  
  /// Convertir le résultat List<ConnectivityResult> en booléen
  bool _isConnectedFromResults(List<ConnectivityResult> results) {
    return results.any((result) => result != ConnectivityResult.none);
  }
}
