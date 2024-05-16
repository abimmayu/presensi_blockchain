class Employee {
  String id;
  String fullName;
  String occupation;
  String lattiude;
  String longitude;
  String presentStatus;
  String reasonForPermission;
  List<String> imagesForPermission;

  Employee({
    required this.id,
    required this.fullName,
    required this.occupation,
    required this.lattiude,
    required this.longitude,
    required this.presentStatus,
    required this.reasonForPermission,
    required this.imagesForPermission,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      fullName: json['full_name'],
      occupation: json['occupation'],
      lattiude: json['lattidue'],
      longitude: json['longitude'],
      presentStatus: json['present_status'],
      reasonForPermission: json['reason_for_permission'],
      imagesForPermission: json['images_for_permission'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'full_name': fullName,
      'occupation': occupation,
      'lattidude': lattiude,
      'longitude': longitude,
      'present_status': presentStatus,
      'reason_for_persmission': reasonForPermission,
      'images_for_permission': List.from(imagesForPermission),
    };

    return json;
  }
}
