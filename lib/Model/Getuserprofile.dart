import 'dart:convert';

GetUserProfile? getAllUsersResponseFromJson(String str) => GetUserProfile.fromJson(json.decode(str));

String getAllUsersResponseToJson(GetUserProfile? data) => json.encode(data!.toJson());


class GetUserProfile {
  final int? id;
  final String? username;
  final String? email;
  final String? mobile;
  final String? address;
  final String? country;
  final String? city;
  final String? pincode;
  final String? name;

  const GetUserProfile({
    this.id,
    this.username,
    this.email,
    this.mobile,
    this.address,
    this.country,
    this.city,
    this.pincode,
    this.name,
  });

  factory GetUserProfile.fromJson(Map<String, dynamic> json) => GetUserProfile(
    id: json["id"],
      username: json["username"],
     email: json["email"],
      mobile: json["mobile"],
    address: json["address"],
    country: json["country"],
    city: json["city"],
    pincode: json["pincode"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
      "email": email,
     "mobile": mobile,
    "address": address,
    "country": country,
    "city": city,
    "pincode": pincode,
    "name": name,
  };


}
