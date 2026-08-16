import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/image_storage_helper.dart';

/// タップして端末ギャラリーから画像を選択し、アプリ専用ディレクトリへ保存するWidget。
/// 保存後のパスを [onImagePicked] で通知する。
class ImagePickerField extends StatelessWidget {
  const ImagePickerField({
    super.key,
    required this.imagePath,
    required this.onImagePicked,
    this.width = 80,
    this.height = 80,
    this.shape = BoxShape.circle,
    this.placeholderIcon = Icons.add_a_photo,
  });

  final String imagePath;
  final ValueChanged<String> onImagePicked;
  final double width;
  final double height;
  final BoxShape shape;
  final IconData placeholderIcon;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final savedPath = await ImageStorageHelper.saveImageFile(File(picked.path));
    onImagePicked(savedPath);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: shape,
          borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(8) : null,
          color: Colors.grey.shade200,
          image: imagePath.isEmpty
              ? null
              : DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.cover),
        ),
        child: imagePath.isEmpty
            ? Icon(placeholderIcon, color: Colors.grey.shade600)
            : null,
      ),
    );
  }
}
