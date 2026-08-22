// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final int typeId = 2;

  @override
  Profile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      id: fields[0] as String,
      name: fields[1] as String,
      iconPath: fields[2] as String,
      bio: fields[3] as String,
      postThumbnailPaths: (fields[4] as List?)?.cast<String>(),
      followUsers: (fields[5] as List?)?.cast<FollowUser>(),
      postCount: fields[6] as int?,
      followerCount: fields[9] as String?,
      followingCount: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.iconPath)
      ..writeByte(3)
      ..write(obj.bio)
      ..writeByte(4)
      ..write(obj.postThumbnailPaths)
      ..writeByte(5)
      ..write(obj.followUsers)
      ..writeByte(6)
      ..write(obj.postCount)
      ..writeByte(9)
      ..write(obj.followerCount)
      ..writeByte(10)
      ..write(obj.followingCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
