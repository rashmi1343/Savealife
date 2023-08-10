import 'dart:convert';

StatesResponse? statesResponseFromJson(String str) => StatesResponse.fromJson(json.decode(str));

String statesResponseToJson(StatesResponse? data) => json.encode(data!.toJson());

class StatesResponse {
  StatesResponse({
    required this.states,
  });

  List<String?>? states;

  factory StatesResponse.fromJson(Map<String, dynamic> json) => StatesResponse(
    states: json["states"] == null ? [] : List<String?>.from(json["states"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "states": states == null ? [] : List<dynamic>.from(states!.map((x) => x)),
  };
}