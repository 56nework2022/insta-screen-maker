// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoryGroupAdapter extends TypeAdapter<StoryGroup> {
  @override
  final int typeId = 4;

  @override
  StoryGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoryGroup(
      id: fields[0] as String,
      ownerName: fields[1] as String,
      ownerIconPath: fields[2] as String,
      images: (fields[3] as List?)?.cast<StoryImage>(),
    );
  }

  @override
  void write(BinaryWriter writer, StoryGroup obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.ownerName)
      ..writeByte(2)
      ..write(obj.ownerIconPath)
      ..writeByte(3)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
