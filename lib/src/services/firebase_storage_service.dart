import 'dart:async';

import 'package:firebase/firebase.dart' as fb;

class FirebaseStorageService {
  static final _storage = fb.storage();

  static Future<fb.UploadTaskSnapshot> uploadPhoto(String path, file) {
    return _storage
        .ref(path)
        .put(file, fb.UploadMetadata(contentType: 'image/png'))
        .future;
  }

  static Future<Uri> getPhotoUri(String path) {
    return _storage.ref(path).getDownloadURL();
  }
}

class FirebaseStoragePath {
  static String passport(String userId) =>
      'images/profiles/$userId/passport.png';

  static String character(String userId) =>
      'images/profiles/$userId/character.png';
}
