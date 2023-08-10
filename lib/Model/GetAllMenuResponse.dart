import 'dart:convert';
import 'dart:ui';

GetAllMenuResponse? getAllMenuResponseFromJson(String str) => GetAllMenuResponse.fromJson(json.decode(str));

String getAllMenuResponseToJson(GetAllMenuResponse? data) => json.encode(data!.toJson());

class GetAllMenuResponse {
  GetAllMenuResponse({
    required this.status,
    required this.menu,
  });

  int? status;
  List<Menu?>? menu;

  factory GetAllMenuResponse.fromJson(Map<String, dynamic> json) => GetAllMenuResponse(
    status: json["status"],
    menu: json["menu"] == null ? [] : List<Menu?>.from(json["menu"]!.map((x) => Menu.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "menu": menu == null ? [] : List<dynamic>.from(menu!.map((x) => x!.toJson())),
  };
}

class Menu {
  Menu({
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

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    id: json["id"],
    menuname: json["menuname"],
    menuslug: json["menuslug"],
    menuicon: json["menuicon"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
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
