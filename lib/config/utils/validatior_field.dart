class ValidatiorField {
  ValidatiorField._();

  static final validate = ValidatiorField._();

  // Expresiones regulares para validación
  final RegExp _usernameRegExp = RegExp(r'^[a-zA-Z]{4,50}$');
  final RegExp _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp _passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{10,60}$');

  String? username(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    } else if (!_usernameRegExp.hasMatch(value)) {
      return 'El nombre debe tener entre 4 y 50 caracteres y no contener números ni caracteres especiales';
    }
    return null;
  }

  String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    } else if (value.length < 6 || value.length > 50) {
      return 'El correo debe tener entre 6 y 50 caracteres';
    } else if (!_emailRegExp.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    } else if (!_passwordRegExp.hasMatch(value)) {
      return 'La contraseña debe tener entre 10 y 60 caracteres, incluir números, letras, una mayúscula, una minúscula y un carácter especial.';
    }
    return null;
  }

  String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    } else if (value != password) {
      return 'Las contraseñas no coinciden';
    }
    return null;
  }
}
