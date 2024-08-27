import '../../config/config.dart' show EncryptionUtil, SharedPref;
import '../service.dart' show UserService;
import '../../models/models.dart' show User;

class AuthService {
  static final serv = AuthService._();
  final userServ = UserService.serv;
  final _dencryptionHelper = EncryptionUtil();
  User? _currentUser;

  AuthService._();

  // Registro de usuario
  Future<User> signUp(String username, String email, String password) async {
    try {
      // Verifica si ya existe un usuario con el mismo email o username
      final usuarios = await userServ.getUsuarios();
      if (usuarios.isNotEmpty) {
        final usuarioExistente = usuarios.firstWhere(
          (usuario) => usuario.email == email || usuario.username == username,
          orElse: () => const User(),
        );
        if (usuarioExistente.id != null) {
          // Si ya existe un usuario con el mismo email o username, devuelve falso
          throw Exception('El usuario ya existe');
        }
      }

      // Crea un nuevo usuario y lo guarda en la base de datos
      final User newUser =
          User(username: username, email: email, password: password);
      await userServ.addUsuario(newUser);
      _currentUser = newUser;
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  // Inicio de sesión
  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      // Obtiene todos los usuarios y busca uno que coincida con el email y password
      final usuarios = await userServ.getUsuarios();
      if (usuarios.isNotEmpty) {
        final usuario = usuarios.firstWhere(
            (usuario) => usuario.email == email && usuario.password == password,
            orElse: () => const User());
        if (usuario.id != null) {
          // Save in Shared preferences
          _currentUser = usuario;
          SharedPref.pref.sessionUser = usuario.toJson();
          return usuario;
        } else {
          throw Exception('No existe ninguna cuenta con estas credenciales');
        }
      } else {
        throw Exception('No existe ninguna cuenta con estas credenciales');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Cerrar sesión
  void logout() {
    SharedPref.pref.sessionUser = {};
    _currentUser = null;
  }

  // Obtener el usuario actual
  User? get currentUser => User.fromJson(SharedPref.pref.sessionUser);
}
