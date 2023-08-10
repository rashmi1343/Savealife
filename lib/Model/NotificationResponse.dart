import 'dart:convert';

NotificationResponse notificationResponseFromJson(String str) => NotificationResponse.fromJson(json.decode(str));

String notificationResponseToJson(NotificationResponse data) => json.encode(data.toJson());

class NotificationResponse {
  NotificationResponse({
    required this.message,
    required this.response,
  });

  String message;
  String response;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) => NotificationResponse(
    message: json["message"],
    response: json["response"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "response": response,
  };
}
