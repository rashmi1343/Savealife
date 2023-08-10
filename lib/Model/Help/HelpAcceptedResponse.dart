import 'dart:convert';

HelpAcceptedResponse helpAcceptedResponseFromJson(String str) => HelpAcceptedResponse.fromJson(json.decode(str));

String helpAcceptedResponseToJson(HelpAcceptedResponse data) => json.encode(data.toJson());

class HelpAcceptedResponse {
  HelpAcceptedResponse({
    required this.status,
    required this.message,
  });

  int status;
  String message;

  factory HelpAcceptedResponse.fromJson(Map<String, dynamic> json) => HelpAcceptedResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
