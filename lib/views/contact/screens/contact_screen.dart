import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../contact.dart' show AddContactForm;
import '../providers/contact_provider.dart' show contactProvider;

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  TextEditingController searchController = TextEditingController();

  void _showAddContactForm(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AddContactForm(
          onSave: (contact) async {
            await ref
                .read(contactProvider.notifier)
                .addContact(contact: contact);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final contactProv = ref.watch(contactProvider);

    return Column(
      children: [
        SafeArea(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: const Text('Mis contactos'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Buscar contacto',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              ref.read(contactProvider.notifier).filterContacts(value);
            },
          ),
        ),
        contactProv.when(
          data: (items) {
            if (items.isNotEmpty) {
              return Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final contact = items[index];
                    return ListTile(
                      title: Text(contact.name ?? ''),
                      subtitle: Text('ID: ${contact.codeId}'),
                    );
                  },
                ),
              );
            } else {
              return const Expanded(
                child: Center(
                  child: Text('No existen contactos'),
                ),
              );
            }
          },
          error: (error, stackTrace) => const Center(
            child: Text('Ocurrió un error'),
          ),
          loading: () => const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: () => _showAddContactForm(context, ref),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Contacto'),
          ),
        ),
      ],
    );
  }
}
