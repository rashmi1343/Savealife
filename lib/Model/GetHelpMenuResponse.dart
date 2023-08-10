import 'dart:convert';
import 'dart:ui';

GetHelpMenuResponse? getHelpMenuResponseFromJson(String str) => GetHelpMenuResponse.fromJson(json.decode(str));

String getHelpMenuResponseToJson(GetHelpMenuResponse? data) => json.encode(data!.toJson());

class GetHelpMenuResponse {
  GetHelpMenuResponse({
    required this.status,
    required this.gethelp,
  });

  int? status;
  List<Gethelp?>? gethelp;

  factory GetHelpMenuResponse.fromJson(Map<String, dynamic> json) => GetHelpMenuResponse(
    status: json["status"],
    gethelp: json["gethelp"] == null ? [] : List<Gethelp?>.from(json["gethelp"]!.map((x) => Gethelp.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "gethelp": gethelp == null ? [] : List<dynamic>.from(gethelp!.map((x) => x!.toJson())),
  };
}

class Gethelp {
  Gethelp({
    required this.id,
    required this.menuname,
    required this.menuslug,
    required this.menuicon,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? menuname;
  String? menuslug;
  String? menuicon;
  String? createdAt;
  String? updatedAt;

  factory Gethelp.fromJson(Map<String, dynamic> json) => Gethelp(
    id: json["id"],
    menuname: json["menuname"],
    menuslug: json["menuslug"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    menuicon: json["menuicon"]

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "menuname": menuname,
    "menuslug": menuslug,
    "menuicon" : menuicon,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
