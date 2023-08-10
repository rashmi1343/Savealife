import 'dart:convert';

AcceptHelpRequestResponse acceptHelpRequestResponseFromJson(String str) => AcceptHelpRequestResponse.fromJson(json.decode(str));

String acceptHelpRequestResponseToJson(AcceptHelpRequestResponse data) => json.encode(data.toJson());

class AcceptHelpRequestResponse {
  AcceptHelpRequestResponse({
    required this.status,
    required this.userhelprequest,
  });

  int status;
  List<Userhelprequest> userhelprequest;

  factory AcceptHelpRequestResponse.fromJson(Map<String, dynamic> json) => AcceptHelpRequestResponse(
    status: json["status"],
    userhelprequest: List<Userhelprequest>.from(json["Userhelprequest"].map((x) => Userhelprequest.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Userhelprequest": List<dynamic>.from(userhelprequest.map((x) => x.toJson())),
  };
}

class Userhelprequest {
  Userhelprequest({
    required this.id,
    required this.fromDevId,
    required this.fromDevToken,
    required this.toDevToken,
    required this.fromUserId,
    required this.toUserId,
    required this.helptype,
    required this.fromLat,
    required this.fromLong,
    required this.sendername,
    required this.senderemail,
    required this.sendermobile,
    required this.ishelpaccepted,
  });

  int id;
  String fromDevId;
  String fromDevToken;
  String toDevToken;
  int fromUserId;
  int toUserId;
  int helptype;
  double fromLat;
  double fromLong;
  String sendername;
  String senderemail;
  String sendermobile;
  int ishelpaccepted;

  factory Userhelprequest.fromJson(Map<String, dynamic> json) => Userhelprequest(
    id: json["id"],
    fromDevId: json["from_dev_id"],
    fromDevToken: json["from_dev_token"],
    toDevToken: json["to_dev_token"],
    fromUserId: json["from_user_id"],
    toUserId: json["to_user_id"],
    helptype: json["helptype"],
    fromLat: json["from_lat"]?.toDouble(),
    fromLong: json["from_long"]?.toDouble(),
    sendername: json["sendername"],
    senderemail: json["senderemail"],
    sendermobile: json["sendermobile"],
    ishelpaccepted: json["ishelpaccepted"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_dev_id": fromDevId,
    "from_dev_token": fromDevToken,
    "to_dev_token": toDevToken,
    "from_user_id": fromUserId,
    "to_user_id": toUserId,
    "helptype": helptype,
    "from_lat": fromLat,
    "from_long": fromLong,
    "sendername": sendername,
    "senderemail": senderemail,
    "sendermobile": sendermobile,
    "ishelpaccepted": ishelpaccepted,
  };
}
