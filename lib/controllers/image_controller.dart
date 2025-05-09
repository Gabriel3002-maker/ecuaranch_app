import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class ImageController {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImageAsBase64() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      return base64Encode(bytes);
    }
    return null;
  }
}
