import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi_blockchain/core/widget/toast.dart';

class FirebaseService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> signInWithemailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(
          message: "Invalid email",
        );
      } else if (e.code == 'wrong-password') {
        showToast(
          message: "Invalid password",
        );
      } else {
        showToast(
          message: 'An error occured: ${e.code}',
        );
      }
      throw Exception(e.message);
    }
  }

  Future<User> signUpWithemailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(
          message: 'The email address is already in use.',
        );
      } else {
        showToast(
          message: 'An error occurred: ${e.code}',
        );
      }
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      final result = auth.signOut();
      return result;
    } on FirebaseAuthException catch (e) {
      showToast(
        message: e.message!,
      );
    }
  }
}
