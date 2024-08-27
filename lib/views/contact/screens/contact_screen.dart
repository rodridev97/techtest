import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../contact.dart' show AddContactForm;
import '../providers/contact_provider.dart'
    show Contact, contactProvider, deviceContactsProvider;

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus != PermissionStatus.granted) {
      // Manejar el caso donde el usuario no otorgó el permiso
      // Mostrar un diálogo o mensaje explicativo
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Contactos App'),
            Tab(text: 'Contactos del Teléfono'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ContactsAppView(),
              DeviceContactsTab(),
            ],
          ),
        ),
      ],
    );
  }
}

class ContactsAppView extends ConsumerStatefulWidget {
  const ContactsAppView({super.key});

  @override
  ConsumerState<ContactsAppView> createState() => _ContactsAppViewState();
}

class _ContactsAppViewState extends ConsumerState<ContactsAppView> {
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
            child: const Text('Contactos de la app'),
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

class DeviceContactsTab extends ConsumerWidget {
  void _editDeviceContact(BuildContext context, Contact contact) {
    // Implementar la función para editar el contacto del dispositivo
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsAsyncValue = ref.watch(deviceContactsProvider);

    return contactsAsyncValue.when(
      data: (contacts) {
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts.elementAt(index);
            return Slidable(
              key: ValueKey(contact.codeId),
              startActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) =>
                        _editDeviceContact(context, contact),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Editar',
                  ),
                ],
              ),
              child: ListTile(
                title: Text(contact.name ?? ''),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) =>
          const Center(child: Text('Error al cargar contactos')),
    );
  }
}
