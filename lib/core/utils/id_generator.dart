import 'package:uuid/uuid.dart';

class IdGenerator {
  const IdGenerator._();

  static const _uuid = Uuid();

  static String generate() => _uuid.v4();
}
