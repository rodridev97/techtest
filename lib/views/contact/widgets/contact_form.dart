import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/contact_provider.dart' show Contact;

class ContactForm extends StatefulWidget {
  final Contact? contact;
  final Function(Contact) onSave;

  ContactForm({this.contact, required this.onSave});

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _numberController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _numberController = TextEditingController(
        text: widget.contact?.phone?.isNotEmpty == true
            ? widget.contact!.phone
            : '');
  }

  bool _validateName(String value) {
    return RegExp(r'^[a-zA-Z\s]{2,50}$').hasMatch(value);
  }

  bool _validateNumber(String value) {
    return RegExp(r'^\d{6,10}$').hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Nombre'),
            validator: (value) {
              if (value == null || value.isEmpty || !_validateName(value)) {
                return 'El nombre debe tener entre 2 y 50 caracteres y no contener números';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _numberController,
            decoration: InputDecoration(labelText: 'Número'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty || !_validateNumber(value)) {
                return 'El número debe tener entre 6 y 10 dígitos';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSave(
                  Contact(
                    name: _nameController.text,
                    phone: _numberController.text,
                  ),
                );
                Navigator.of(context).pop(); // Cierra el formulario
              }
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }
}
