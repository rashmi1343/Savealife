import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.mobile,
    required this.name,
    required this.accessToken,
  });

  int? id;
  String username;
  String email;
  String mobile;
  String name;
  String accessToken;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    mobile: json["mobile"],
    name: json["name"],
    accessToken: json["accessToken"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "mobile": mobile,
    "name": name,
    "accessToken": accessToken,
  };
}