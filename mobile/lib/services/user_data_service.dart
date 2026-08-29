import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;
  UserDataService._internal();

  static const _keyQuestionnaireCompleted = 'questionnaire_completed';
  static const _keyRecommendations = 'last_recommendations';
  static const _keyUserLevel = 'user_classe';
  static const _keyUserName = 'user_name';
  static const _keyUserAge = 'user_age';
  static const _keyUserRegion = 'user_region';
  static const _keyProfileComplete = 'profile_complete';

  // ── Questionnaire ─────────────────────────────────────────────────────────

  Future<bool> isQuestionnaireCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyQuestionnaireCompleted) ?? false;
  }

  Future<void> markQuestionnaireCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyQuestionnaireCompleted, true);
  }

  Future<void> resetQuestionnaire() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyQuestionnaireCompleted, false);
    await prefs.remove(_keyRecommendations);
  }

  // ── Recommandations ───────────────────────────────────────────────────────

  Future<void> saveRecommendations(
    List<Map<String, dynamic>> recommendations,
    String userLevel,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRecommendations, jsonEncode(recommendations));
    await prefs.setString(_keyUserLevel, userLevel);
    await markQuestionnaireCompleted();
  }

  Future<List<Map<String, dynamic>>> getRecommendations() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyRecommendations);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<String> getUserLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserLevel) ?? '3ème';
  }

  // ── Profil ────────────────────────────────────────────────────────────────

  Future<void> saveProfile({
    required String name,
    required String age,
    required String region,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserAge, age);
    await prefs.setString(_keyUserRegion, region);
    await prefs.setBool(_keyProfileComplete, true);
  }

  Future<Map<String, String>> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_keyUserName) ?? '',
      'age': prefs.getString(_keyUserAge) ?? '',
      'region': prefs.getString(_keyUserRegion) ?? '',
    };
  }

  Future<bool> isProfileComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyProfileComplete) ?? false;
  }

  // ── % complétion profil ───────────────────────────────────────────────────

  Future<int> getProfileCompletionPercent() async {
    final prefs = await SharedPreferences.getInstance();
    int score = 0;
    if (prefs.getBool(_keyQuestionnaireCompleted) ?? false) score += 50;
    if ((prefs.getString(_keyUserName) ?? '').isNotEmpty) score += 20;
    if ((prefs.getString(_keyUserAge) ?? '').isNotEmpty) score += 15;
    if ((prefs.getString(_keyUserRegion) ?? '').isNotEmpty) score += 15;
    return score;
  }
}