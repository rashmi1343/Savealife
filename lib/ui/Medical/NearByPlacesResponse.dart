import 'dart:convert';

NearByPlacesResponse? nearByPlacesResponseFromJson(String str) =>
    NearByPlacesResponse.fromJson(json.decode(str));

String nearByPlacesResponseToJson(NearByPlacesResponse? data) =>
    json.encode(data!.toJson());

class NearByPlacesResponse {
  String? nextPageToken;
  List<Results>? results;
  String? status;

  NearByPlacesResponse(
      {required this.nextPageToken,
        required this.results,
        required this.status});

  NearByPlacesResponse.fromJson(Map<String, dynamic> json) {
    nextPageToken = json['next_page_token'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['next_page_token'] = this.nextPageToken;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Results {
  String? businessStatus;
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  OpeningHours? openingHours;
  List<Photos>? photos;
  String? placeId;
  PlusCode? plusCode;


  String? reference;
  String? scope;
  List<String>? types;
  int? userRatingsTotal;
  String? vicinity;

  Results(
      {this.businessStatus,
        this.geometry,
        this.icon,
        this.iconBackgroundColor,
        this.iconMaskBaseUri,
        this.name,
        this.openingHours,
        this.photos,
        this.placeId,
        this.plusCode,

        this.reference,
        this.scope,
        this.types,
        this.userRatingsTotal,
        this.vicinity});

  Results.fromJson(Map<String, dynamic> json) {
    businessStatus = json['business_status'];
    geometry =
    json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    openingHours = json['opening_hours'] != null
        ? OpeningHours.fromJson(json['opening_hours'])
        : null;
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(Photos.fromJson(v));
      });
    }
    placeId = json['place_id'];
    plusCode =
    json['plus_code'] != null ? PlusCode.fromJson(json['plus_code']) : null;


    reference = json['reference'];
    scope = json['scope'];
    types = json['types'].cast<String>();
    userRatingsTotal = json['user_ratings_total'];
    vicinity = json['vicinity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['business_status'] = this.businessStatus;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['icon'] = this.icon;
    data['icon_background_color'] = this.iconBackgroundColor;
    data['icon_mask_base_uri'] = this.iconMaskBaseUri;
    data['name'] = this.name;
    if (this.openingHours != null) {
      data['opening_hours'] = this.openingHours!.toJson();
    }
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = this.placeId;
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode!.toJson();
    }

    data['reference'] = this.reference;

    data['scope'] = this.scope;
    data['types'] = this.types;
    data['user_ratings_total'] = this.userRatingsTotal;
    data['vicinity'] = this.vicinity;
    return data;
  }
}

class Geometry {
  LocationPlace? locationplace;
  Viewports? viewport;

  Geometry({this.locationplace, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    locationplace =
    json['location'] != null ? LocationPlace.fromJson(json['location']) : null;
    viewport =
    json['viewport'] != null ? Viewports.fromJson(json['viewport']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.locationplace != null) {
      data['location'] = this.locationplace!.toJson();
    }
    if (this.viewport != null) {
      data['viewport'] = this.viewport!.toJson();
    }
    return data;
  }
}

class LocationPlace {
  double? lat;
  double? lng;

  LocationPlace({this.lat, this.lng});

  LocationPlace.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Viewports {
  LocationPlace? northeast;
  LocationPlace? southwest;

  Viewports({this.northeast, this.southwest});

  Viewports.fromJson(Map<String, dynamic> json) {
    northeast =
    json['northeast'] != null ? LocationPlace.fromJson(json['northeast']) : null;
    southwest =
    json['southwest'] != null ? LocationPlace.fromJson(json['southwest']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.northeast != null) {
      data['northeast'] = this.northeast!.toJson();
    }
    if (this.southwest != null) {
      data['southwest'] = this.southwest!.toJson();
    }
    return data;
  }
}

class OpeningHours {
  bool? openNow;

  OpeningHours({this.openNow});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['open_now'] = this.openNow;
    return data;
  }
}

class Photos {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['height'] = this.height;
    data['html_attributions'] = this.htmlAttributions;
    data['photo_reference'] = this.photoReference;
    data['width'] = this.width;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['compound_code'] = this.compoundCode;
    data['global_code'] = this.globalCode;
    return data;
  }
}
