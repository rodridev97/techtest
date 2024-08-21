import 'package:flutter/material.dart';

import '../../../config/config.dart' show SharedPref;
import '../../user/user.dart' show User;
import '../providers/contact_provider.dart' show Contact;

class AddContactForm extends StatefulWidget {
  final Function(Contact) onSave;

  const AddContactForm({super.key, required this.onSave});

  @override
  _AddContactFormState createState() => _AddContactFormState();
}

class _AddContactFormState extends State<AddContactForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _identifier = '';
  late User user;

  bool _isNameValid(String value) {
    final regex = RegExp(r'^[a-zA-Z\s]+$');
    return value.isNotEmpty &&
        regex.hasMatch(value) &&
        value.length >= 2 &&
        value.length <= 50;
  }

  bool _isIdentifierValid(String value) {
    final regex = RegExp(r'^\d+$');
    return value.isNotEmpty &&
        regex.hasMatch(value) &&
        value.length >= 6 &&
        value.length <= 10;
  }

  @override
  void initState() {
    super.initState();
    user = User.fromJson(SharedPref.pref.sessionUser);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nombre del contacto',
                  errorMaxLines: 2,
                ),
                maxLength: 50,
                validator: (value) {
                  if (value == null || !_isNameValid(value)) {
                    return 'Ingrese un nombre válido (solo letras, 2-50 caracteres)';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Identificación',
                  errorMaxLines: 2,
                ),
                keyboardType: TextInputType.text,
                maxLength: 10,
                validator: (value) {
                  if (value == null || !_isIdentifierValid(value)) {
                    return 'Ingrese una identificación válida (solo números, 6-10 caracteres)';
                  }
                  return null;
                },
                onSaved: (value) {
                  _identifier = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onSave(
                      Contact(
                        name: _name,
                        codeId: _identifier,
                        userId: user.id,
                      ),
                    );
                  }
                },
                child: const Text('Guardar Contacto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
