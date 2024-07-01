import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? address;
  String? deviceId;
  String? id;
  String? name;
  num? nip;
  String? occupation;
  bool? publicKey;
  String? role;

  UserData({
    this.address,
    this.deviceId,
    this.id,
    this.name,
    this.nip,
    this.occupation,
    this.publicKey,
    this.role,
  });

  factory UserData.fromJson(DocumentSnapshot json) {
    return UserData(
      address: json["address"],
      deviceId: json["device_id"],
      id: json["id"],
      name: json["name"],
      nip: json["nip"],
      occupation: json["occupation"],
      publicKey: json["public_key"],
      role: json["role"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "address": address,
      "device_id": deviceId,
      "id": id,
      "name": name,
      "nip": nip,
      "occupation": occupation,
      "public_key": publicKey,
      "role": role,
    };
  }
}
