// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_image.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryImageAdapter extends TypeAdapter<StoryImage> {
  @override
  final int typeId = 5;

  @override
  StoryImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryImage(
      id: fields[0] as String,
      imagePath: fields[1] as String,
      order: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, StoryImage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.order);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
