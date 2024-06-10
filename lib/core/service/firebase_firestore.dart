import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FireStore {
  final firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getData({
    required String doc,
    required String collection,
  }) async {
    final DocumentReference document = firestore
        .collection(
          collection,
        )
        .doc(
          doc,
        );
    Logger().i(document);
    final DocumentSnapshot result = await document.get();
    Logger().d(result);
    return result;
  }

  Future<void> addData({
    required String doc,
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    final DocumentReference document = firestore
        .collection(
          collection,
        )
        .doc(
          doc,
        );
    Logger().i(document);
    final result = await document.set(data);
    return result;
  }

  Future<void> updateData({
    required String doc,
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    final DocumentReference document =
        firestore.collection(collection).doc(doc);
    Logger().i(document);
    final result = await document.update(data);
    return result;
  }
}
