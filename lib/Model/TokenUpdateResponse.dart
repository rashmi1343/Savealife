import 'dart:convert';

TokenUpdateResponse tokenUpdateResponseFromJson(String str) => TokenUpdateResponse.fromJson(json.decode(str));

String tokenUpdateResponseToJson(TokenUpdateResponse data) => json.encode(data.toJson());

class TokenUpdateResponse {
  TokenUpdateResponse({
    required this.status,
    required this.message,
  });

  int status;
  String message;

  factory TokenUpdateResponse.fromJson(Map<String, dynamic> json) => TokenUpdateResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
