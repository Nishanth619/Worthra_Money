import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../core/network/api_client.dart';
import '../core/network/auth_token_store.dart';
import 'database_provider.dart';

// ---------------------------------------------------------------------------
// Token store provider — single instance shared across providers
// ---------------------------------------------------------------------------

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  return AuthTokenStore(storage);
});

// ---------------------------------------------------------------------------
// ApiClient provider
// ---------------------------------------------------------------------------

final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenStore = ref.watch(authTokenStoreProvider);
  return ApiClient(tokenStore: tokenStore);
});

// ---------------------------------------------------------------------------
// Auth user model
// ---------------------------------------------------------------------------

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
  });

  final String id;
  final String email;
  final String name;

  String get displayInitial => name.isNotEmpty
      ? name.trim().substring(0, 1).toUpperCase()
      : email.substring(0, 1).toUpperCase();
}

// ---------------------------------------------------------------------------
// AuthController — manages session state
// ---------------------------------------------------------------------------

class AuthController extends AsyncNotifier<AuthUser?> {
  @override
  Future<AuthUser?> build() async {
    final tokenStore = ref.watch(authTokenStoreProvider);
    final isAuthed = await tokenStore.isAuthenticated;
    if (!isAuthed) return null;

    final userId = await tokenStore.userId;
    final email = await tokenStore.userEmail;
    final name = await tokenStore.userName;

    if (userId == null || email == null || name == null) return null;

    return AuthUser(id: userId, email: email, name: name);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final client = ref.read(apiClientProvider);
      final tokenStore = ref.read(authTokenStoreProvider);

      final response = await client.postPublic(
        '/auth/login',
        {'email': email, 'password': password},
      );

      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;
      final user = response['user'] as Map<String, dynamic>;
      final userId = user['id'] as String;
      final userName = user['name'] as String? ?? email.split('@').first;

      await tokenStore.save(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        userEmail: email,
        userName: userName,
      );

      // Persist userId in app settings for offline identity
      final settingsRepo =
          await ref.read(settingsRepositoryProvider.future);
      await settingsRepo.updateUserId(userId);

      return AuthUser(id: userId, email: email, name: userName);
    });
  }

  Future<void> signup(String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final client = ref.read(apiClientProvider);
      final tokenStore = ref.read(authTokenStoreProvider);

      final response = await client.postPublic(
        '/auth/signup',
        {'name': name, 'email': email, 'password': password},
      );

      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;
      final user = response['user'] as Map<String, dynamic>;
      final userId = user['id'] as String;

      await tokenStore.save(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
        userEmail: email,
        userName: name,
      );

      final settingsRepo =
          await ref.read(settingsRepositoryProvider.future);
      await settingsRepo.updateUserId(userId);

      return AuthUser(id: userId, email: email, name: name);
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      // Best-effort server logout — ignore network errors
      final client = ref.read(apiClientProvider);
      await client.delete('/auth/logout');
    } catch (_) {}

    final tokenStore = ref.read(authTokenStoreProvider);
    await tokenStore.clear();

    final settingsRepo = await ref.read(settingsRepositoryProvider.future);
    await settingsRepo.updateUserId(null);

    state = const AsyncData(null);
  }
}

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthUser?>(AuthController.new);
