import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore {
  final firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getData({
    required String doc,
    required String collection,
  }) async {
    final DocumentReference document =
        firestore.collection(collection).doc(doc);

    final DocumentSnapshot result = await document.get();
    return result;
  }
}
