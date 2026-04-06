import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists JWT access + refresh tokens in the platform secure keychain.
///
/// On Android, this uses EncryptedSharedPreferences (API 23+).
/// On iOS, this uses the Keychain.
class AuthTokenStore {
  const AuthTokenStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessKey = 'pf_access_token';
  static const _refreshKey = 'pf_refresh_token';
  static const _userIdKey = 'pf_user_id';
  static const _userEmailKey = 'pf_user_email';
  static const _userNameKey = 'pf_user_name';

  Future<String?> get accessToken => _storage.read(key: _accessKey);
  Future<String?> get refreshToken => _storage.read(key: _refreshKey);
  Future<String?> get userId => _storage.read(key: _userIdKey);
  Future<String?> get userEmail => _storage.read(key: _userEmailKey);
  Future<String?> get userName => _storage.read(key: _userNameKey);

  Future<bool> get isAuthenticated async {
    final token = await accessToken;
    return token != null && token.isNotEmpty;
  }

  Future<void> save({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String userEmail,
    required String userName,
  }) async {
    await Future.wait([
      _storage.write(key: _accessKey, value: accessToken),
      _storage.write(key: _refreshKey, value: refreshToken),
      _storage.write(key: _userIdKey, value: userId),
      _storage.write(key: _userEmailKey, value: userEmail),
      _storage.write(key: _userNameKey, value: userName),
    ]);
  }

  Future<void> clear() => _storage.deleteAll();
}
