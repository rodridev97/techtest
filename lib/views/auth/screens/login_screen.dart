import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/config.dart'
    show
        DiagonalPainter,
        EncryptionUtil,
        NotificationMessages,
        SharedPref,
        ValidatiorField;
import '../auth.dart' show User, authProvider;
import 'register_screen.dart';
import '../../common/common.dart' show MainScreen;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final _encryptionHelper = EncryptionUtil();
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool isObscurePassword = true;
  bool _canCheckBiometrics = false;
  bool _isBiometricAssociated = false;

  Future<void> _checkBiometricSupport() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _checkBiometricAssociation() async {
    bool? isBiometricAssociated = SharedPref.pref.isBiometricEnrolled;

    if (isBiometricAssociated) {
      setState(() {
        _isBiometricAssociated = true;
      });
    }
  }

  Future<void> _handleSubmitSignIn(Size size) async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(authProvider.notifier)
          .signIn(
            email: _emailCtrl.text.replaceAll(' ', ''),
            password: _passwordCtrl.text.replaceAll(' ', ''),
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

  Future<void> _authenticateAndLogin(Size size) async {
    bool authenticated = await auth.authenticate(
      localizedReason: 'Autentícate para iniciar sesión',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    if (authenticated) {
      // Obtener credenciales desencriptadas
      User? userSaved = User.fromJson(SharedPref.pref.sessionUser);

      // Inicia sesión con las credenciales obtenidas
      _login(
        size,
        username: userSaved.username ?? '',
        password: userSaved.password ?? '',
      );
    }
  }

  Future<void> _login(Size size,
      {required String username, required String password}) async {
    await ref
        .read(authProvider.notifier)
        .signIn(
          email: _emailCtrl.text.replaceAll(' ', ''),
          password: _passwordCtrl.text.replaceAll(' ', ''),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkBiometricSupport();
    _checkBiometricAssociation();
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
                      validator: (value) =>
                          ValidatiorField.validate.email(value),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
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
                      validator: (value) =>
                          ValidatiorField.validate.password(value),
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _handleSubmitSignIn(size),
                      child: const Text('Iniciar Sesión'),
                    ),
                    SizedBox(height: size.height * 0.05),
                    IconButton(
                        onPressed: () => _authenticateAndLogin(size),
                        icon: const Icon(
                          FontAwesomeIcons.fingerprint,
                          size: 30,
                        )),
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
