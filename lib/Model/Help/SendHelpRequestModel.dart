// To parse this JSON data, do
//
//     final sendHelpRequestModel = sendHelpRequestModelFromJson(jsonString);

import 'dart:convert';

SendHelpRequestModel sendHelpRequestModelFromJson(String str) =>
    SendHelpRequestModel.fromJson(json.decode(str));

String sendHelpRequestModelToJson(SendHelpRequestModel data) =>
    json.encode(data.toJson());

class SendHelpRequestModel {
  SendHelpRequestModel({
    this.fromDevId,
    this.fromDevToken,
    this.toDevId,
    this.toDevToken,
    this.fromUserId,
    this.toUserId,
    this.helptype,
    this.fromDevType,
    this.toDevType,
    this.fromLat,
    this.fromLong,
    this.toLat,
    this.toLong,
    this.fromAddress,
    this.toAddress,
    this.message,
    this.sendername,
    this.senderemail,
    this.sendermobile,

  });

  String? fromDevId;
  String? fromDevToken;
  String? toDevId;
  String? toDevToken;
  String? fromUserId;
  String? toUserId;
  int? helptype;
  String? fromDevType;
  String? toDevType;
  double? fromLat;
  double? fromLong;
  double? toLat;
  double? toLong;
  String? fromAddress;
  String? toAddress;
  String? message;
  String? sendername;
  String? senderemail;
  String? sendermobile;


  factory SendHelpRequestModel.fromJson(Map<String, dynamic> json) =>
      SendHelpRequestModel(
        fromDevId: json["from_dev_id"],
        fromDevToken: json["from_dev_token"],
        toDevId: json["to_dev_id"],
        toDevToken: json["to_dev_token"],
        fromUserId: json["from_user_id"],
        toUserId: json["to_user_id"],
        helptype: json["helptype"],
        fromDevType: json["from_dev_type"],
        toDevType: json["to_dev_type"],
        fromLat: json["from_lat"],
        fromLong: json["from_long"],
        toLat: json["to_lat"],
        toLong: json["to_long"],
        fromAddress: json["from_address"],
        toAddress: json["to_address"],
        message: json["message"],
        sendername: json["sendername"],
        senderemail: json["senderemail"],
        sendermobile: json["sendermobile"],
      );

  Map<String, dynamic> toJson() => {
        "from_dev_id": fromDevId,
        "from_dev_token": fromDevToken,
        "to_dev_id": toDevId,
        "to_dev_token": toDevToken,
        "from_user_id": fromUserId,
        "to_user_id": toUserId,
        "helptype": helptype,
        "from_dev_type": fromDevType,
        "to_dev_type": toDevType,
        "from_lat": fromLat,
        "from_long": fromLong,
        "to_lat": toLat,
        "to_long": toLong,
        "from_address": fromAddress,
        "to_address": toAddress,
        "message": message,
        "sendername": sendername,
        "senderemail": senderemail,
        "sendermobile": sendermobile,
      };
}
