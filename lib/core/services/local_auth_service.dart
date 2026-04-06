import 'package:local_auth/local_auth.dart';

class LocalAuthAvailability {
  const LocalAuthAvailability({
    required this.isDeviceSupported,
    required this.canCheckBiometrics,
    required this.availableBiometrics,
  });

  final bool isDeviceSupported;
  final bool canCheckBiometrics;
  final List<BiometricType> availableBiometrics;

  bool get hasEnrolledBiometrics => availableBiometrics.isNotEmpty;
}

class LocalAuthResult {
  const LocalAuthResult({
    required this.isAuthenticated,
    this.message,
  });

  final bool isAuthenticated;
  final String? message;
}

class LocalAuthFailure implements Exception {
  const LocalAuthFailure(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'LocalAuthFailure(message: $message, cause: $cause)';
}

abstract class ILocalAuthService {
  Future<LocalAuthAvailability> getAvailability();
  Future<void> ensureBiometricsAvailable();
  Future<LocalAuthResult> authenticate({required String reason});
  Future<void> cancelAuthentication();
}

class LocalAuthService implements ILocalAuthService {
  LocalAuthService([LocalAuthentication? localAuthentication])
    : _localAuthentication = localAuthentication ?? LocalAuthentication();

  final LocalAuthentication _localAuthentication;

  @override
  Future<LocalAuthAvailability> getAvailability() async {
    try {
      final isDeviceSupported = await _localAuthentication.isDeviceSupported();
      final canCheckBiometrics =
          isDeviceSupported && await _localAuthentication.canCheckBiometrics;
      final availableBiometrics = canCheckBiometrics
          ? await _localAuthentication.getAvailableBiometrics()
          : const <BiometricType>[];

      return LocalAuthAvailability(
        isDeviceSupported: isDeviceSupported,
        canCheckBiometrics: canCheckBiometrics,
        availableBiometrics: availableBiometrics,
      );
    } on LocalAuthException catch (error) {
      throw LocalAuthFailure(_messageForException(error), error);
    } catch (error) {
      throw LocalAuthFailure(
        'Unable to determine biometric availability on this device.',
        error,
      );
    }
  }

  @override
  Future<void> ensureBiometricsAvailable() async {
    final availability = await getAvailability();

    if (!availability.isDeviceSupported) {
      throw const LocalAuthFailure(
        'This device does not support secure local authentication.',
      );
    }

    if (!availability.canCheckBiometrics) {
      throw const LocalAuthFailure(
        'Biometric hardware is unavailable on this device.',
      );
    }

    if (!availability.hasEnrolledBiometrics) {
      throw const LocalAuthFailure(
        'No biometrics are enrolled. Add a fingerprint or face unlock first.',
      );
    }
  }

  @override
  Future<LocalAuthResult> authenticate({required String reason}) async {
    try {
      final authenticated = await _localAuthentication.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      if (!authenticated) {
        return const LocalAuthResult(
          isAuthenticated: false,
          message: 'Biometric authentication was cancelled.',
        );
      }

      return const LocalAuthResult(isAuthenticated: true);
    } on LocalAuthException catch (error) {
      throw LocalAuthFailure(_messageForException(error), error);
    } catch (error) {
      throw LocalAuthFailure(
        'Biometric authentication failed unexpectedly.',
        error,
      );
    }
  }

  @override
  Future<void> cancelAuthentication() async {
    try {
      await _localAuthentication.stopAuthentication();
    } catch (_) {
      // Best effort only; a failed cancel should not block the app.
    }
  }
}

String _messageForException(LocalAuthException error) {
  return switch (error.code) {
    LocalAuthExceptionCode.noBiometricsEnrolled =>
      'No biometrics are enrolled. Add a fingerprint or face unlock first.',
    LocalAuthExceptionCode.noBiometricHardware =>
      'Biometric hardware is unavailable on this device.',
    LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable =>
      'Biometric hardware is temporarily unavailable. Try again in a moment.',
    LocalAuthExceptionCode.temporaryLockout =>
      'Biometric authentication is temporarily locked. Try again later.',
    LocalAuthExceptionCode.biometricLockout =>
      'Biometric authentication is locked. Unlock the device and try again.',
    LocalAuthExceptionCode.userCanceled =>
      'Biometric authentication was cancelled.',
    LocalAuthExceptionCode.systemCanceled =>
      'Biometric authentication was interrupted. Try again.',
    LocalAuthExceptionCode.noCredentialsSet =>
      'Secure device credentials are not configured on this device.',
    LocalAuthExceptionCode.authInProgress =>
      'Biometric authentication is already in progress.',
    LocalAuthExceptionCode.uiUnavailable =>
      'Biometric authentication UI is unavailable right now.',
    LocalAuthExceptionCode.timeout =>
      'Biometric authentication timed out. Try again.',
    LocalAuthExceptionCode.userRequestedFallback =>
      'A biometric check is required to unlock this app.',
    LocalAuthExceptionCode.deviceError =>
      error.description ??
      'The device reported an error during biometric authentication.',
    LocalAuthExceptionCode.unknownError =>
      error.description ?? 'An unknown biometric authentication error occurred.',
  };
}
