import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../config/config.dart'
    show DiagonalPainter, NotificationMessages, ValidatiorField;
import '../auth.dart' show authProvider;

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static const String routeName = '/register';

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late FocusNode _focusNodeUsername;
  late FocusNode _focusNodeEmail;
  late FocusNode _focusNodePassword;
  bool isObscurePassword = true;
  bool isObscureRepPassword = true;

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .signUp(
            username: _usernameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          )
          .then((value) {
        Navigator.of(context).pop();
        NotificationMessages.success(
          context,
          message: 'Registro Completado',
          title: 'Usuario registrado correctamente',
        );
      }).catchError((e) {
        String message = e.toString().replaceAll(RegExp(r'^Exception: '), '');
        NotificationMessages.error(context, message: message, title: 'Error');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNodeUsername = FocusNode();
    _focusNodeEmail = FocusNode();
    _focusNodePassword = FocusNode();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _focusNodeUsername.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Expanded(
        child: CustomPaint(
          painter: DiagonalPainter(context: context),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.08),
                      const Text(
                        'Registrarse',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        focusNode: _focusNodeUsername,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          labelText: 'Nombre de Usuario',
                          border: OutlineInputBorder(),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'[a-zA-Z]')),
                        ],
                        validator: (value) =>
                            ValidatiorField.validate.username(value),
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _focusNodeEmail,
                        enableSuggestions: false,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            ValidatiorField.validate.email(value),
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: isObscurePassword,
                        controller: _passwordController,
                        focusNode: _focusNodePassword,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          border: const OutlineInputBorder(),
                          errorMaxLines: 3,
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
                        validator: (value) =>
                            ValidatiorField.validate.password(value),
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: isObscureRepPassword,
                        decoration: InputDecoration(
                          labelText: 'Confirmar Contraseña',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscureRepPassword = !isObscureRepPassword;
                              });
                            },
                            icon: isObscureRepPassword
                                ? const Icon(FontAwesomeIcons.eye)
                                : const Icon(FontAwesomeIcons.eyeSlash),
                          ),
                        ),
                        validator: (value) => ValidatiorField.validate
                            .confirmPassword(value, _passwordController.text),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                      ),
                      const SizedBox(height: 20),
                      Consumer(
                        builder: (context, ref, child) {
                          final authProv = ref.read(authProvider);
                          return !authProv.isLoading
                              ? ElevatedButton(
                                  onPressed: () => _handleRegister(),
                                  child: const Text('Registrarse'),
                                )
                              : const ElevatedButton(
                                  onPressed: null,
                                  child: CircularProgressIndicator(),
                                );
                        },
                      ),
                      SizedBox(height: size.height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Ya tengo una cuenta'),
                          TextButton(
                            onPressed: () {
                              // Volver a la pantalla de login
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Iniciar Sesión',
                              style: TextStyle(fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
