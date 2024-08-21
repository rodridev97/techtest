import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageUtil {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImage({required ImageSource source}) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(pickedFile.path);
      final savedImage = File('${appDir.path}/$fileName');
      final imageFile = await File(pickedFile.path).copy(savedImage.path);
      return imageFile.path;
    } else {
      return null;
    }
  }
}
