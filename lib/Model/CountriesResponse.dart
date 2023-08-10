import 'dart:convert';

CountriesResponse? countriesResponseFromJson(String str) => CountriesResponse.fromJson(json.decode(str));

String countriesResponseToJson(CountriesResponse? data) => json.encode(data!.toJson());

class CountriesResponse {
  CountriesResponse({
    required this.countries,
  });

  List<Country?>? countries;

  factory CountriesResponse.fromJson(Map<String, dynamic> json) => CountriesResponse(
    countries: json["countries"] == null ? [] : List<Country?>.from(json["countries"]!.map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "countries": countries == null ? [] : List<dynamic>.from(countries!.map((x) => x!.toJson())),
  };
}

class Country {
  Country({
    required this.name,
    required this.code,
    required this.dialCode,
  });

  String? name;
  String? code;
  String? dialCode;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    name: json["name"],
    code: json["code"],
    dialCode: json["dial_code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "dial_code": dialCode,
  };
}
