import '../../config/config.dart' show Strings;
import '../../models/models.dart' show User;
import '../service.dart' show LocalDatabaseService;

class UserService {
  UserService._();

  static final serv = UserService._();

  // Métodos para Usuario

  Future<int> addUsuario(User usuario) async {
    final db = await LocalDatabaseService.db.database;
    return await db.insert(Strings.userTable, usuario.toJson());
  }

  Future<List<User>> getUsuarios() async {
    try {
      final db = await LocalDatabaseService.db.database;
      final result = await db.query(Strings.userTable);
      return result.map((map) => User.fromJson(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUsuario({required User usuario}) async {
    final db = await LocalDatabaseService.db.database;
    final res = await db.update(
      Strings.userTable,
      usuario.toJson(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
    if (res != 0) {
      return usuario;
    } else {
      throw Exception('No se pudo actualizar el registro');
    }
  }

  Future<int> deleteUsuario(int id) async {
    final db = await LocalDatabaseService.db.database;
    return await db.delete(
      Strings.userTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
