import 'dart:convert';

SignUpResponse? signUpResponseFromJson(String str) => SignUpResponse.fromJson(json.decode(str));

String signUpResponseToJson(SignUpResponse? data) => json.encode(data!.toJson());

class SignUpResponse {
  SignUpResponse({
    required this.message,
    required this.otp,
    required this.id,
    required this.username,
    required this.email,
    required this.mobile,
  });

  String? message;
  int otp;
  int id;
  String username;
  String email;
  String mobile;

  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
    message: json["message"],
    otp: json["otp"],
    id: json["id"],
    username: json["username"],
    email: json["email"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "otp": otp,
    "id": id,
    "username": username,
    "email": email,
    "mobile": mobile,
  };
}