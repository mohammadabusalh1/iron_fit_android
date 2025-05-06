import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime_type/mime_type.dart';

Future<String?> uploadData(String path, Uint8List data) async {
  final storageRef = FirebaseStorage.instance.ref().child(path);
  final metadata = SettableMetadata(contentType: mime(path));
  final result = await storageRef.putData(data, metadata);
  return result.state == TaskState.success ? result.ref.getDownloadURL() : null;
}

/// Downloads a file from Firebase Storage as bytes
///
/// Returns the file data as Uint8List or throws an exception if the file doesn't exist
Future<Uint8List> downloadBytes(String path) async {
  final storageRef = FirebaseStorage.instance.ref().child(path);
  final data = await storageRef.getData();
  if (data == null) {
    throw Exception('File not found or empty: $path');
  }
  return data;
}
