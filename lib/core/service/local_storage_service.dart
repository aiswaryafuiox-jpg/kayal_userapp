import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static SharedPreferences? _prefs;

  static const String keySessionId = 'session_id';
  static const String keyHasSeenOnboarding = 'hasSeenOnboarding';
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyFullName = 'full_name';
  static const String keyUserName = 'user_name';
  static const String keyPhoneNumber = 'phone_number';
  static const String keyEmail = 'email';

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  String getOrCreateSessionId() {
    String? session = getString(keySessionId);
    if (session == null || session.trim().isEmpty) {
      session = DateTime.now().millisecondsSinceEpoch.toString();
      saveString(keySessionId, session);
    }
    return session;
  }

  String? getSessionId() {
    return getString(keySessionId);
  }

  Future<void> saveSessionId(String sessionId) async {
    await saveString(keySessionId, sessionId);
  }

  bool hasSeenOnboarding() {
    return getBool(keyHasSeenOnboarding) ?? false;
  }

  Future<void> setSeenOnboarding(bool seen) async {
    await saveBool(keyHasSeenOnboarding, seen);
  }

  bool isLoggedIn() {
    return getBool(keyIsLoggedIn) ?? false;
  }

  Future<void> setLoggedIn(bool loggedIn) async {
    await saveBool(keyIsLoggedIn, loggedIn);
  }

  String? getFullName() {
    return getString(keyFullName) ?? getString(keyUserName);
  }

  String? getPhoneNumber() {
    return getString(keyPhoneNumber);
  }

  String? getEmail() {
    return getString(keyEmail);
  }

  Future<void> saveUserData({
    String? fullName,
    String? phoneNumber,
    String? email,
  }) async {
    if (fullName != null && fullName.trim().isNotEmpty) {
      await saveString(keyFullName, fullName.trim());
      await saveString(keyUserName, fullName.trim());
    }
    if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
      await saveString(keyPhoneNumber, phoneNumber.trim());
    }
    if (email != null && email.trim().isNotEmpty) {
      await saveString(keyEmail, email.trim());
    }
  }

  String? getString(String key) {
    return _prefs?.getString(key);
  }

  Future<bool> saveString(String key, String value) async {
    return await _prefs?.setString(key, value) ?? false;
  }

  bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  Future<bool> saveBool(String key, bool value) async {
    return await _prefs?.setBool(key, value) ?? false;
  }

  Future<bool> remove(String key) async {
    return await _prefs?.remove(key) ?? false;
  }

  Future<bool> clear() async {
    return await _prefs?.clear() ?? false;
  }
}
