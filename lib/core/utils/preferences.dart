import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalPreferences {
  set wallet(String? value);

  String? get wallet;
}

class LocalPrefrencesImpl implements LocalPreferences {
  final SharedPreferences shared;

  LocalPrefrencesImpl({required this.shared});

  @override
  set wallet(String? value) => shared.setString("wallet", value!);

  @override
  String? get wallet => shared.getString("wallet");

  static Future<LocalPreferences> instance() =>
      SharedPreferences.getInstance().then(
        (value) => LocalPrefrencesImpl(shared: value),
      );
}
