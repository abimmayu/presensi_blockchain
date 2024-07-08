import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';

class FirebaseService {
  FirebaseAuth auth = FirebaseAuth.instance;
  SecureStorage secureStorage = SecureStorage();

  Future<User> signInWithemailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Logger().d(userCredential.user);
    secureStorage.writeData(key: AppConstant.userEmail, value: email);
    secureStorage.writeData(key: AppConstant.userPassword, value: password);
    return userCredential.user!;
  }

  Future<User> signUpWithemailAndPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    Logger().d(userCredential.user);

    return userCredential.user!;
  }

  Future<void> signOut() async {
    final result = await auth.signOut();
    return result;
  }

  Future<void> changePassword(String newPassword) async {
    final user = auth.currentUser!;
    final result = await user.updatePassword(newPassword);
    secureStorage.writeData(
      key: AppConstant.userPassword,
      value: newPassword,
    );
    return result;
  }
}
