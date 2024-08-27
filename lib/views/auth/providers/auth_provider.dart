import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techtest/views/contact/providers/contact_provider.dart';

import '../../../config/config.dart' show EncryptionUtil, SharedPref;
import '../../../models/models.dart' show User;
export '../../../models/models.dart' show User;
import '../../../services/service.dart' show AuthService;
import '../../user/user.dart' show userProvider;

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User>>((ref) {
  return AuthNotifier(service: AuthService.serv);
});

class AuthNotifier extends StateNotifier<AsyncValue<User>> {
  AuthNotifier({required this.service}) : super(const AsyncValue.data(User()));

  final AuthService service;
  final _encryptionHelper = EncryptionUtil();

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      // Encriptar la contraseña antes de guardarla en SQLite
      String encryptedPassword = await _encryptionHelper.encrypt(password);

      final User? userAuth =
          await service.signIn(email: email, password: encryptedPassword);
      if (userAuth != null) {
        // Saved user login in preferences
        SharedPref.pref.sessionUser = userAuth.toJson();
        state = AsyncValue.data(userAuth);
      }
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
      rethrow;
    }
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      // Encriptar la contraseña antes de guardarla en SQLite
      String encryptedPassword = await _encryptionHelper.encrypt(password);

      final user = await service.signUp(username, email, encryptedPassword);

      // Saved user login in preferences
      SharedPref.pref.sessionUser = user.toJson();

      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }
  }
}

final authSignOutProvider = StateProvider<void>((ref) {
  // Dispose Shared Pref
  AuthService.serv.logout();

  // Disposable all providers
  ref.invalidate(authProvider);
  ref.invalidate(userProvider);
  ref.invalidate(contactProvider);
  return;
});
