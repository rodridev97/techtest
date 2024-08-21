import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/config.dart' show SharedPref;
import '../../../services/service.dart' show Contact, ContactService;
import '../../user/user.dart' show User;
export '../../../services/service.dart' show Contact;

final contactProvider = AsyncNotifierProvider<ContactNotifier, List<Contact>>(
    () => ContactNotifier.new(service: ContactService.contactServ));

class ContactNotifier extends AsyncNotifier<List<Contact>> {
  ContactNotifier({required this.service});

  final ContactService service;
  List<Contact> _allContacts = []; // Lista completa de contactos

  @override
  FutureOr<List<Contact>> build() {
    return loadContacts();
  }

  Future<List<Contact>> loadContacts() async {
    state = const AsyncValue.loading();
    final userSession = User.fromJson(SharedPref.pref.sessionUser);
    try {
      final result = await service.getContacts(userId: userSession.id ?? 0);
      state = AsyncValue.data(result);
      _allContacts = result;
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
    }

    return state.value ?? [];
  }

  Future<void> addContact({required Contact contact}) async {
    state = const AsyncValue.loading();
    try {
      await service.addContact(contact: contact);
      await loadContacts();
    } catch (e) {
      state = AsyncError(e.toString(), StackTrace.current);
      rethrow;
    }
  }

  void filterContacts(String query) {
    state = AsyncValue.data(_allContacts
        .where((Contact contact) =>
            contact.name?.toLowerCase().contains(query.toLowerCase()) ??
            false || (contact.codeId?.contains(query) ?? false))
        .toList());

    if (query == '') {
      state = AsyncValue.data(_allContacts);
    }
  }
}
