import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static Future<void> setDocumentData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) {
    return Firestore.instance.document(path).setData(data, merge: merge);
  }

  static Future<void> createDocument({
    required collectionPath,
    required Map<String, dynamic> data,
  }) {
    return Firestore.instance.collection(collectionPath).add(data);
  }

  static Future<void> deleteDocument({required String path}) {
    return Firestore.instance.document(path).delete();
  }

  static Future<DocumentSnapshot> getDocument({required String path}) {
    return Firestore.instance.document(path).get();
  }

  static Future<List<DocumentSnapshot>> getCollection({
    required String path,
    Query Function(Query query)? queryBuilder,
  }) async {
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = await query.getDocuments();
    return snapshots.documents;
  }

  static Stream<List<DocumentSnapshot>> collectionStream({
    required String path,
    Query Function(Query query)? queryBuilder,
  }) {
    Query query = Firestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots().map((snapshot) => snapshot.documents);
  }

  static Stream<DocumentSnapshot> documentStream({required String path}) {
    return Firestore.instance.document(path).snapshots();
  }

  static Future<void> updateDocument({
    required String path,
    required Map<String, dynamic> data,
  }) {
    return Firestore.instance.document(path).updateData(data);
  }
}
