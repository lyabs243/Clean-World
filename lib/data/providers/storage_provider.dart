import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageProvider {

  Future<String> upload({required Uint8List fileData, required String fileName, String fileType = '',
    String? storageReference}) async {
    try {
      Reference firebaseStorageRef = FirebaseStorage.instance
          .ref(storageReference)
          .child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putData(fileData,
          (fileType.isNotEmpty)? SettableMetadata(contentType: fileType): null);
      TaskSnapshot storageSnapshot = await uploadTask;
      String downloadUrl = await storageSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch(e) {
      debugPrint('==============Error uploading file: - $e');
    }

    return '';
  }

}