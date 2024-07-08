import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_time_detail.dart';

class PresentTime {
  PresentTimeDetail start;
  PresentTimeDetail end;

  PresentTime({
    required this.start,
    required this.end,
  });

  factory PresentTime.fromJson(Map<String, dynamic> json) {
    return PresentTime(
      start: PresentTimeDetail.fromJson(
        json['start'],
      ),
      end: PresentTimeDetail.fromJson(
        json['end'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start.toJson(),
      'end': end.toJson(),
    };
  }
}
