class PresentTimeDetail {
  int hour;
  int minute;

  PresentTimeDetail({
    required this.hour,
    required this.minute,
  });

  factory PresentTimeDetail.fromJson(Map<String, dynamic> json) {
    return PresentTimeDetail(
      hour: json['hour'],
      minute: json['minute'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'minute': minute,
    };
  }
}
