import 'package:presensi_blockchain/core/service/firebase_service.dart';

abstract class UserSettingsDataPost {
  Future<void> changePassword(String newPassword);
}

class UserSettingsDataPostImpl implements UserSettingsDataPost {
  FirebaseService auth = FirebaseService();

  @override
  Future<void> changePassword(String newPassword) async {
    final result = auth.changePassword(newPassword);
    return result;
  }
}
