import 'dart:typed_data';

class OfflineBook {
  final String title;
  final String id;
  final String libraryId;
  final Uint8List bytes;

  OfflineBook({
    required this.title,
    required this.id,
    required this.libraryId,
    required this.bytes,
  });
}
