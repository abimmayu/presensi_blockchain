import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  Future<void> writeData({
    required String key,
    required dynamic value,
  }) async {
    final result = await storage.write(key: key, value: value);
    return result;
  }

  Future<String> readData({
    required String key,
  }) async {
    final result = await storage.read(key: key);
    return result!;
  }
}
