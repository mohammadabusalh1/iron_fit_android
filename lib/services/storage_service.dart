import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<List<XFile>?> pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      return images;
    } catch (e) {
      print('Error picking images: $e');
      return null;
    }
  }

  Future<List<String>> uploadImages(List<XFile> images, String gymId) async {
    List<String> downloadUrls = [];

    try {
      for (var image in images) {
        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        Reference ref = _storage.ref().child('gyms/$gymId/$fileName');

        await ref.putFile(File(image.path));
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
    } catch (e) {
      print('Error uploading images: $e');
      throw Exception('Failed to upload images: $e');
    }

    return downloadUrls;
  }

  Future<void> deleteImages(List<String> imageUrls) async {
    try {
      for (var url in imageUrls) {
        Reference ref = _storage.refFromURL(url);
        await ref.delete();
      }
    } catch (e) {
      print('Error deleting images: $e');
      throw Exception('Failed to delete images: $e');
    }
  }
}
