class Employee {
  String id;
  BigInt nip;
  String fullName;
  String occupation;

  Employee({
    required this.id,
    required this.nip,
    required this.fullName,
    required this.occupation,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      nip: json['nip'],
      fullName: json['full_name'],
      occupation: json['occupation'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'nip': nip,
      'full_name': fullName,
      'occupation': occupation,
    };
    return json;
  }
}
