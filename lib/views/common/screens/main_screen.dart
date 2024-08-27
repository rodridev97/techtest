import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

import '../../../config/config.dart';
import '../../contact/contact.dart' show ContactScreen;
import '../../contact/providers/contact_provider.dart';
import '../../user/user.dart' show UserScreen;

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  static const String routeName = '/main';

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  final LocalAuthentication auth = LocalAuthentication();
  Timer? _sessionTimer;
  Timer? _dialogTimer;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 1:
          ref.refresh(contactProvider.future);
          break;
        default:
      }
    });
  }

  Future<void> _checkBiometricEnrollment() async {
    bool isBiometricEnrolled = SharedPref.pref.isBiometricEnrolled;

    // Mostrar el dialogo solo si no está configurado
    if (!isBiometricEnrolled) {
      _showBiometricDialog();
    }
  }

  void _showBiometricDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Asociar biometría'),
          content: Text(
              '¿Deseas asociar tus credenciales con la biometría registrada en tu dispositivo para un inicio de sesión más rápido?'),
          actions: <Widget>[
            TextButton(
              child: Text('No, gracias'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sí, asociar'),
              onPressed: () {
                _authenticateAndSave();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _authenticateAndSave() async {
    bool authenticated = await auth.authenticate(
      localizedReason: 'Por favor autentícate para asociar tu biometría',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );

    if (authenticated) {
      SharedPref.pref.isBiometricEnrolled = true;
      // Aquí podrías guardar las credenciales o tokens en SQLite
      // usando una clave segura, por ejemplo, con FlutterSecureStorage
    }
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer =
        Timer(const Duration(minutes: 2), _showSessionRenewalDialog);
  }

  void _showSessionRenewalDialog() {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Evita que se cierre al tocar fuera del diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sesión expirada'),
          content: const Text('¿Deseas renovar tu sesión o cerrarla?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar sesión'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                _logout();
              },
            ),
            TextButton(
              child: const Text('Renovar sesión'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                _renewSession();
              },
            ),
          ],
        );
      },
    );

    // Si el usuario no responde en 10 segundos, cerrar sesión automáticamente
    _dialogTimer = Timer(Duration(seconds: 10), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Cierra el diálogo
        _logout();
      }
    });
  }

  void _renewSession() {
    _dialogTimer?.cancel();
    _startSessionTimer(); // Reinicia el temporizador de la sesión
  }

  void _logout() {
    _sessionTimer?.cancel();
    _dialogTimer?.cancel();
    // Redirige a la pantalla de inicio
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    _startSessionTimer();
    _checkBiometricEnrollment();
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _dialogTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          UserScreen(),
          ContactScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(FontAwesomeIcons.solidCircleUser),
            icon: Icon(FontAwesomeIcons.circleUser),
            label: 'Inicio',
          ),
          NavigationDestination(
            selectedIcon: Icon(FontAwesomeIcons.solidAddressBook),
            icon: Icon(FontAwesomeIcons.addressBook),
            label: 'Contactos',
          )
        ],
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
