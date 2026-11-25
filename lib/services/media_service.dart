import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> tirarFoto() async {
    final foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1080,
    );
    return foto == null ? null : File(foto.path);
  }

  Future<File?> selecionarDaGaleria() async {
    final imagem = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1080,
    );
    return imagem == null ? null : File(imagem.path);
  }
}
