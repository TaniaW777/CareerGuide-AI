import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectivityProvider with ChangeNotifier {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _offlineFirstMode = false;

  ConnectivityProvider() {
    _loadSettings();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  ConnectivityResult get connectionStatus => _connectionStatus;
  bool get isConnected => _connectionStatus != ConnectivityResult.none;
  bool get offlineFirstMode => _offlineFirstMode;

  String get connectionLabel {
    if (!isConnected) return "Hors-ligne";
    if (_connectionStatus == ConnectivityResult.wifi) return "Connecté (Wi-Fi)";
    if (_connectionStatus == ConnectivityResult.mobile) return "Connecté (Données)";
    return "Connecté";
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
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      debugPrint('Couldn\'t check connectivity status: $e');
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    // On prend le premier résultat significatif ou 'none'
    if (results.isEmpty) {
      _connectionStatus = ConnectivityResult.none;
    } else {
      // Priorité au Wifi si plusieurs connexions
      if (results.contains(ConnectivityResult.wifi)) {
        _connectionStatus = ConnectivityResult.wifi;
      } else if (results.contains(ConnectivityResult.mobile)) {
        _connectionStatus = ConnectivityResult.mobile;
      } else if (results.contains(ConnectivityResult.vpn)) {
        _connectionStatus = ConnectivityResult.vpn;
      } else if (results.contains(ConnectivityResult.ethernet)) {
        _connectionStatus = ConnectivityResult.ethernet;
      } else {
        _connectionStatus = results.first;
      }
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
