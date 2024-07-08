import 'package:presensi_blockchain/feature/user_settings/domain/entity/present_time.dart';

class PresentTimeModel {
  PresentTime getIn;
  PresentTime getOut;

  PresentTimeModel({
    required this.getIn,
    required this.getOut,
  });

  factory PresentTimeModel.fromJson(
    Map<String, dynamic> jsonIn,
    Map<String, dynamic> jsonOut,
  ) {
    return PresentTimeModel(
      getIn: PresentTime.fromJson(jsonIn),
      getOut: PresentTime.fromJson(jsonOut),
    );
  }
}
