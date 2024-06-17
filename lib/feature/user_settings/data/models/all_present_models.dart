import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_result.dart';

class AllPresentModels {
  final String status;
  final String message;
  final List<PresentResult> result;
  AllPresentModels({
    required this.status,
    required this.message,
    required this.result,
  });

  factory AllPresentModels.fromJson(Map<String, dynamic> json) {
    return AllPresentModels(
      status: json['status'],
      message: json['message'],
      result: List.from(
        (json['result'] as List).map(
          (e) => PresentResult.fromJson(e),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': List<PresentResult>.from(
        result.map(
          (e) => e.toJson(),
        ),
      ),
    };
  }
}
