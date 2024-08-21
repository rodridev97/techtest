import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/config.dart' show ImageUtil, SharedPref;
import '../../../models/models.dart' show User;
import '../../../services/service.dart' show UserService;
export '../../../models/models.dart' show User;

final userProvider =
    StateNotifierProvider<UserNotifier, AsyncValue<User>>((ref) {
  final imageUtil = ImageUtil();
  return UserNotifier(imageUtil, service: UserService.serv);
});

class UserNotifier extends StateNotifier<AsyncValue<User>> {
  UserNotifier(this._imageService, {required this.service})
      : super(const AsyncValue.loading());

  final UserService service;
  final ImageUtil _imageService;

  // Método para actualizar el usuario
  Future<User> updateUser({required User user}) async {
    state = const AsyncValue.loading();
    try {
      final userUp = await service.updateUsuario(usuario: user);
      if (userUp.id != null) {
        state = AsyncValue.data(userUp);
      }
      return userUp;
    } catch (e) {
      rethrow;
    }
  }

  // Método para actualizar la imagen de perfil
  Future<String?> updateProfileImage(
      {required User user, required ImageSource source}) async {
    final imagePath = await _imageService.pickImage(source: source);
    if (imagePath != null) {
      try {
        final userUp = await updateUser(
          user: user.copyWith(imageUrl: imagePath),
        );
        // Update Preferences
        SharedPref.pref.sessionUser = userUp.toJson();
      } catch (e) {
        rethrow;
      }
    }
    return imagePath;
  }
}
