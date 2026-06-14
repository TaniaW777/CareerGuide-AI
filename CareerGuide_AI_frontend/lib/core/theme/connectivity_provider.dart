import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/backend_config.dart';
import 'package:http/http.dart' as http;

class ConnectivityProvider with ChangeNotifier {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _offlineFirstMode = false;
  bool _isBackendOnline = false;
  bool _isGemmaReady = false;
  String _modeLabel = '🔴 OFFLINE';

  ConnectivityProvider() {
    _loadSettings();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  ConnectivityResult get connectionStatus => _connectionStatus;
  bool get isConnected => _connectionStatus != ConnectivityResult.none;
  bool get offlineFirstMode => _offlineFirstMode;
  bool get isBackendOnline => _isBackendOnline;
  bool get isGemmaReady => _isGemmaReady;
  String get modeLabel => _modeLabel;

  String get connectionLabel {
    if (!isConnected) return 'Hors-ligne';
    if (_connectionStatus == ConnectivityResult.wifi) return 'Connecté (Wi-Fi)';
    if (_connectionStatus == ConnectivityResult.mobile) return 'Connecté (Données)';
    if (_connectionStatus == ConnectivityResult.vpn) return 'Connecté (VPN)';
    if (_connectionStatus == ConnectivityResult.ethernet) return 'Connecté (Ethernet)';
    return 'Connecté';
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _offlineFirstMode = prefs.getBool('offline_first_mode') ?? false;
    notifyListeners();
  }

  Future<void> setOfflineFirstMode(bool value) async {
    _offlineFirstMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('offline_first_mode', value);
    notifyListeners();
  }

  Future<void> forceCheckConnectivity() async {
    await _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
      await _checkBackendStatus();
    } catch (e) {
      debugPrint('Couldn\'t check connectivity status: $e');
      _connectionStatus = ConnectivityResult.none;
      _isBackendOnline = false;
      _isGemmaReady = false;
      _updateModeLabel();
      notifyListeners();
    }
  }

  Future<void> _checkBackendStatus() async {
    if (!isConnected) {
      _isBackendOnline = false;
      _isGemmaReady = false;
      _updateModeLabel();
      return;
    }

    try {
      final response = await http
          .get(BackendConfig.modelStatusUri())
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _isBackendOnline = true;
        _isGemmaReady = data['gemma_ready'] == true;
        _updateModeLabel();
      } else {
        _isBackendOnline = false;
        _isGemmaReady = false;
        _updateModeLabel();
      }
    } catch (e) {
      debugPrint('Backend status check failed: $e');
      _isBackendOnline = false;
      _isGemmaReady = false;
      _updateModeLabel();
    }
    notifyListeners();
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.none)) {
      _connectionStatus = ConnectivityResult.none;
    } else if (result.isNotEmpty) {
      _connectionStatus = result.first;
    } else {
      _connectionStatus = ConnectivityResult.none;
    }
    _updateModeLabel();
    notifyListeners();

    if (isConnected) {
      _checkBackendStatus();
    } else {
      _isBackendOnline = false;
      _isGemmaReady = false;
      _updateModeLabel();
      notifyListeners();
    }
  }

  void _updateModeLabel() {
    if (_isBackendOnline && _isGemmaReady) {
      _modeLabel = '🟢 Connecté';
    } else if (_isBackendOnline) {
      _modeLabel = '🟡 Connecté';
    } else if (isConnected) {
      _modeLabel = '🟢 Connecté';
    } else {
      _modeLabel = '🔴 Déconnecté';
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
