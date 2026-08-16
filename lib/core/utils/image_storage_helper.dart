import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'id_generator.dart';

/// image_pickerが返す一時パスはOSに削除・無効化される可能性があるため、
/// アプリ専用ディレクトリへ複製してからパスをHiveに保存する(architecture.md 3.4節)。
class ImageStorageHelper {
  const ImageStorageHelper._();

  static const _imagesDirName = 'picapp_images';

  static Future<String> saveImageFile(File sourceFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDir.path, _imagesDirName));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }
    final fileName = '${IdGenerator.generate()}${p.extension(sourceFile.path)}';
    final savedFile = await sourceFile.copy(p.join(imagesDir.path, fileName));
    return savedFile.path;
  }

  static Future<void> deleteImageFile(String imagePath) async {
    final file = File(imagePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
