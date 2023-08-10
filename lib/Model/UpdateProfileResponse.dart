import 'dart:convert';

UpdateProfileResponse? updateProfileResponseFromJson(String str) =>
    UpdateProfileResponse.fromJson(json.decode(str));

String updateProfileResponseToJson(UpdateProfileResponse? data) =>
    json.encode(data!.toJson());

class UpdateProfileResponse {
  UpdateProfileResponse({
    required this.status,
    required this.message,
  });

  int? status;
  String? message;

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) =>
      UpdateProfileResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
