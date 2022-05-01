import 'package:avataria_search/src/services/firebase_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PassportViewPage extends StatelessWidget {
  final String userId;

  PassportViewPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: FutureBuilder<Uri>(
                future: FirebaseStorageService.getPhotoUri(
                  FirebaseStoragePath.passport(userId),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Произошла ошибка при загрузке паспорта: ${snapshot.error}',
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    return PhotoView(
                      imageProvider: NetworkImage(snapshot.data.toString()),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
