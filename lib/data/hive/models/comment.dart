import 'package:hive/hive.dart';

part 'comment.g.dart';

@HiveType(typeId: 1)
class Comment {
  Comment({
    required this.id,
    required this.userName,
    required this.userIconPath,
    required this.body,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String userIconPath;

  @HiveField(3)
  final String body;

  Comment copyWith({
    String? userName,
    String? userIconPath,
    String? body,
  }) {
    return Comment(
      id: id,
      userName: userName ?? this.userName,
      userIconPath: userIconPath ?? this.userIconPath,
      body: body ?? this.body,
    );
  }
}
