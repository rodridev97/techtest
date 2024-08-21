import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../config/config.dart' show DiagonalPainter, NotificationMessages;
import '../auth.dart' show authProvider;
import 'register_screen.dart';
import '../../common/common.dart' show MainScreen;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool isObscurePassword = true;

  Future<void> _handleSubmitSignIn(Size size) async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .signIn(
            email: _emailCtrl.text,
            password: _passwordCtrl.text,
          )
          .then((value) {
        Navigator.of(context).pushNamed(MainScreen.routeName);
      }).catchError((e) {
        String message = e.toString().replaceAll(RegExp(r'^Exception: '), '');
        NotificationMessages.error(
          context,
          message: message,
          title: 'Credenciales Incorrectas',
          height: size.height * 0.18,
          width: size.width * 0.80,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomPaint(
        painter: DiagonalPainter(context: context),
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.12),
                    const Text(
                      'Iniciar Sesión',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: isObscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscurePassword = !isObscurePassword;
                            });
                          },
                          icon: isObscurePassword
                              ? const Icon(FontAwesomeIcons.eye)
                              : const Icon(FontAwesomeIcons.eyeSlash),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _handleSubmitSignIn(size),
                      child: const Text('Iniciar Sesión'),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('No tengo una cuenta'),
                              TextButton(
                                onPressed: () {
                                  // Navegar a la pantalla de registro
                                  Navigator.of(context)
                                      .pushNamed(RegisterScreen.routeName);
                                },
                                child: const Text(
                                  'Registrarse',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
