import 'dart:convert' as json;

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static final SharedPref pref = SharedPref._();

  SharedPreferences? preferences;

  SharedPref._();

  Future<void> initPrefer() async {
    preferences = await SharedPreferences.getInstance();
  }

  // Getters
  String get operateCurrency =>
      preferences?.getString('operationCurrency') ?? 'COIN';
  bool get showApp => preferences?.getBool('showApp') ?? false;
  bool get isRememberCredential =>
      preferences?.getBool('isRememberCredential') ?? false;
  List<String> get loginCredential =>
      preferences?.getStringList('credentials') ?? [];

  bool get allowNotifications => preferences?.getBool('notification') ?? false;

  bool get isBiometricEnrolled =>
      preferences?.getBool('biometric_enrolled') ?? false;

  Map<String, dynamic> get sessionUser =>
      json.jsonDecode(preferences?.getString('sessionUser') ?? '{}')
          as Map<String, dynamic>;

  // Setters
  set operateCurrency(String newCurrency) =>
      preferences?.setString('operationCurrency', newCurrency);
  set showApp(bool flag) => preferences?.setBool('showApp', flag);
  set isBiometricEnrolled(bool flag) =>
      preferences?.setBool('biometric_enrolled', flag);
  set isRememberCredential(bool flag) =>
      preferences?.setBool('isRememberCredential', flag);
  set loginCredential(List<String> credentials) =>
      preferences?.setStringList('credentials', credentials);

  set allowNotifications(bool flag) =>
      preferences?.setBool('notification', flag);

  set sessionUser(Map<String, dynamic> user) =>
      preferences?.setString('sessionUser', json.jsonEncode(user));
}
