import '../../config/config.dart' show Strings;
import '../../models/models.dart' show Contact;
export '../../models/models.dart' show Contact;
import '../service.dart' show LocalDatabaseService;

class ContactService {
  ContactService._();

  static final contactServ = ContactService._();

  // Métodos para Contact

  Future<Contact> addContact({required Contact contact}) async {
    final db = await LocalDatabaseService.db.database;
    final res = await db.insert(Strings.contactTable, contact.toJson());
    if (res != 0) {
      return contact;
    } else {
      throw Exception('No se pudo agregar el registro');
    }
  }

  Future<List<Contact>> getContacts({required int userId}) async {
    final db = await LocalDatabaseService.db.database;
    final result = await db
        .query(Strings.contactTable, where: 'user_id = ?', whereArgs: [userId]);
    return result.map((map) => Contact.fromJson(map)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await LocalDatabaseService.db.database;
    return await db.update(
      Strings.contactTable,
      contact.toJson(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await LocalDatabaseService.db.database;
    return await db.delete(
      Strings.contactTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
