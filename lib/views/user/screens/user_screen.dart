import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../config/config.dart' show NotificationMessages, SharedPref;
import '../../auth/auth.dart' show LoginScreen, User, authSignOutProvider;
import '../user.dart' show userProvider;

class UserScreen extends ConsumerStatefulWidget {
  const UserScreen({super.key});

  @override
  ConsumerState<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends ConsumerState<UserScreen> {
  late User username;
  int selectedIndex = 0;
  String? _userImage;

  // Método para mostrar opciones para agregar o editar imagen de usuario
  Future<void> _showImageOptions({required Size size}) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: size.height * 0.25,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Tomar Foto'),
              onTap: () {
                _pickImage(size, source: ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Elegir de la Galería'),
              onTap: () {
                _pickImage(size, source: ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Método para seleccionar imagen desde la cámara o galería
  Future<void> _pickImage(Size size, {required ImageSource source}) async {
    // final pickedFile = await _picker.pickImage(source: source);
    // if (pickedFile != null) {
    //   setState(() {
    //     _userImage = pickedFile.path;
    //   });
    // }
    try {
      final image = await ref.read(userProvider.notifier).updateProfileImage(
          source: source, user: User.fromJson(SharedPref.pref.sessionUser));
      if (image != null) {
        setState(() {
          _userImage = image;
        });
      }
    } catch (e) {
      String message = e.toString().replaceAll(RegExp(r'^Exception: '), '');
      NotificationMessages.error(
        context,
        message: message,
        title: 'Error',
        height: size.height * 0.18,
        width: size.width * 0.80,
      );
    }
  }

  void _handleLogOut(Size size) {
    try {
      ref.read(authSignOutProvider.notifier);
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      String message = e.toString().replaceAll(RegExp(r'^Exception: '), '');
      NotificationMessages.error(
        context,
        message: message,
        title: 'Error',
        height: size.height * 0.15,
        width: size.width * 0.80,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    username = User.fromJson(SharedPref.pref.sessionUser);
    _userImage = username.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SafeArea(
            child: Container(
              height: size.height * 0.08,
              color: Theme.of(context).appBarTheme.backgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'Perfil de ${username.username}',
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _handleLogOut(size),
                    icon: const Icon(FontAwesomeIcons.rightToBracket),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _userImage != null
                        ? FileImage(File(_userImage!))
                        : const AssetImage('assets/imgs/no-image.jpg')
                            as ImageProvider,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _showImageOptions(size: size),
                    icon: const Icon(FontAwesomeIcons.penToSquare),
                    label: const Text('Agregar/Editar Imagen'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
