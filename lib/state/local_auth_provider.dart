import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/local_auth_service.dart';

final localAuthServiceProvider = Provider<ILocalAuthService>((ref) {
  return LocalAuthService();
});
