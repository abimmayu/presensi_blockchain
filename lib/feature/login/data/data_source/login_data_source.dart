import 'package:firebase_auth/firebase_auth.dart';
import 'package:presensi_blockchain/core/service/firebase_service.dart';

abstract class AuthDataSource {
  Future<User?> login(String email, String password);
  Future<User?> signUp(String email, String password);
  Future<void> signOut();
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseService firebaseService = FirebaseService();

  @override
  Future<User?> login(
    String email,
    String password,
  ) async {
    final result = await firebaseService.signInWithemailAndPassword(
      email,
      password,
    );
    return result;
  }

  @override
  Future<User?> signUp(
    String email,
    String password,
  ) async {
    final result = await firebaseService.signUpWithemailAndPassword(
      email,
      password,
    );
    return result;
  }

  @override
  Future<void> signOut() async {
    final result = await firebaseService.signOut();
    return result;
  }
}
