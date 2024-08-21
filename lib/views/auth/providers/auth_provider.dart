import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:techtest/views/contact/providers/contact_provider.dart';

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

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final userAuth = await service.signIn(email: email, password: password);
      if (userAuth != null) {
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
      final user = await service.signUp(username, email, password);
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
