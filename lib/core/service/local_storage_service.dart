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
  static const String keyLatitude = 'latitude';
  static const String keyLongitude = 'longitude';
  static const String keyAddress = 'address';
  static const String keyCity = 'city';
  static const String keyState = 'state';
  static const String keyPincode = 'pincode';

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
    final token = getString(keyAuthToken) ?? getString('token');
    final hasValidToken = token != null &&
        token.trim().isNotEmpty &&
        !token.startsWith('pms_token_');
    final loggedInFlag = (getBool(keyIsLoggedIn) ?? false) ||
        (getBool('is_logged_in') ?? false);
    return loggedInFlag && hasValidToken;
  }

  Future<void> setLoggedIn(bool loggedIn) async {
    await saveBool(keyIsLoggedIn, loggedIn);
    await saveBool('is_logged_in', loggedIn);
  }

  Future<void> clearUserData() async {
    await _prefs?.setBool(keyIsLoggedIn, false);
    await _prefs?.setBool('is_logged_in', false);
    await _prefs?.remove(keyAuthToken);
    await _prefs?.remove('token');
    await _prefs?.remove(keyUserId);
    await _prefs?.remove(keyFullName);
    await _prefs?.remove(keyUserName);
    await _prefs?.remove('name');
    await _prefs?.remove(keyPhoneNumber);
    await _prefs?.remove('phone');
    await _prefs?.remove('user_phone');
    await _prefs?.remove(keyEmail);
    await _prefs?.remove(keyAddress);
    await _prefs?.remove(keyCity);
    await _prefs?.remove(keyState);
    await _prefs?.remove(keyPincode);
    await _prefs?.remove(keyLatitude);
    await _prefs?.remove(keyLongitude);
    await _prefs?.remove(keySessionId);
    getOrCreateSessionId();
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

  double getLatitude() {
    final lat = _prefs?.getDouble(keyLatitude);
    if (lat != null) return lat;
    final latStr = getString(keyLatitude);
    if (latStr != null) {
      return double.tryParse(latStr) ?? 13.0827;
    }
    return 13.0827;
  }

  double getLongitude() {
    final lng = _prefs?.getDouble(keyLongitude);
    if (lng != null) return lng;
    final lngStr = getString(keyLongitude);
    if (lngStr != null) {
      return double.tryParse(lngStr) ?? 80.2707;
    }
    return 80.2707;
  }

  String? getAddress() {
    return getString(keyAddress);
  }

  String? getCity() {
    return getString(keyCity);
  }

  Future<void> saveLocation({
    required double latitude,
    required double longitude,
    String? address,
    String? city,
    String? state,
    String? pincode,
  }) async {
    await _prefs?.setDouble(keyLatitude, latitude);
    await _prefs?.setDouble(keyLongitude, longitude);
    if (address != null && address.trim().isNotEmpty) {
      await saveString(keyAddress, address.trim());
    }
    if (city != null && city.trim().isNotEmpty) {
      await saveString(keyCity, city.trim());
    }
    if (state != null && state.trim().isNotEmpty) {
      await saveString(keyState, state.trim());
    }
    if (pincode != null && pincode.trim().isNotEmpty) {
      await saveString(keyPincode, pincode.trim());
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
