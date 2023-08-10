import 'dart:convert';

GetAllUsersResponse getAllUsersResponseFromJson(String str) => GetAllUsersResponse.fromJson(json.decode(str));

String getAllUsersResponseToJson(GetAllUsersResponse data) => json.encode(data.toJson());

class GetAllUsersResponse {
  GetAllUsersResponse({
    required this.status,
    required this.users,
  });

  int status;
  List<User> users;

  factory GetAllUsersResponse.fromJson(Map<String, dynamic> json) => GetAllUsersResponse(
    status: json["status"],
    users: List<User>.from(json["Users"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Users": List<dynamic>.from(users.map((x) => x.toJson())),
  };
}

class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.mobile,
    required this.address,
    required this.city,
    required this.pincode,
    required this.name,
    required this.deviceid,
    required this.devtoken,
    required this.devtype,
    required this.lat,
    required this.long,
  });

  int id;
  String username;
  String email;
  String mobile;
  String address;
  String city;
  String pincode;
  dynamic name;
  String deviceid;
  String devtoken;
  String devtype;
  double lat;
  double long;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    mobile: json["mobile"],
    address: json["address"],
    city: json["city"],
    pincode: json["pincode"],
    name: json["name"],
    deviceid: json["deviceid"],
    devtoken: json["devtoken"],
    devtype: json["devtype"],
    lat: json["lat"],
    long: json["long"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "mobile": mobile,
    "address": address,
    "city": city,
    "pincode": pincode,
    "name": name,
    "deviceid": deviceid,
    "devtoken": devtoken,
    "devtype": devtype,
    "lat": lat,
    "long": long,
  };
}
