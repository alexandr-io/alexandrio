import 'dart:typed_data';

import 'package:amberkit/amberkit.dart';

part 'offlinebook.g.dart';

@HiveType(typeId: 12)
class OfflineBook extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String libraryId;
  @HiveField(3)
  final Uint8List bytes;

  OfflineBook({
    required this.title,
    required this.id,
    required this.libraryId,
    required this.bytes,
  });
}
