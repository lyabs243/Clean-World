import 'dart:typed_data';
import 'package:structure/data/providers/storage_provider.dart';

class StorageRepository {

  final StorageProvider provider = StorageProvider();

  Future<String> uploadFile({String fileType = '', String storageReference = '', required Uint8List bytes, required String name}) async {
    return await provider.upload(fileData: bytes, fileName: name, storageReference: storageReference,
      fileType: fileType);
  }

}