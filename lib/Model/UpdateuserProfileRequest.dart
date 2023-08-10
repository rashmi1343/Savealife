import 'dart:convert';

UpdateuserProfileRequest? userProfileResponseFromJson(String str) =>
    UpdateuserProfileRequest.fromJson(json.decode(str));

String userProfileResponseToJson(UpdateuserProfileRequest? data) =>
    json.encode(data!.toJson());

class UpdateuserProfileRequest {
  UpdateuserProfileRequest({
    required this.id,
    //required this.username,
    //required this.email,
    // required this.mobile,
    required this.address,
    required this.country,
    required this.city,
    required this.pincode,
   required this.name,
   required this.lat,
   required this.long,
  });

  int? id;
  //String? username;
  // String? email;
  // String? mobile;
  String? address;
  String? country;
  String? city;
  String? pincode;
  String? name;
  double? lat;
  double? long;

  factory UpdateuserProfileRequest.fromJson(Map<String, dynamic> json) =>
      UpdateuserProfileRequest(
        id: json["id"],
        //  username: json["username"],
        //  email: json["email"],
        //  mobile: json["mobile"],
        address: json["address"],
        country: json["country"],
        city: json["city"],
        pincode: json["pincode"],
         name: json["name"],
        lat: json["lat"],
        long: json["long"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // "username": username,
        //  "email": email,
        // "mobile": mobile,
        "address": address,
        "country": country,
        "city": city,
        "pincode": pincode,
     "name": name,
     "lat": lat,
     "long": long,
      };
}
