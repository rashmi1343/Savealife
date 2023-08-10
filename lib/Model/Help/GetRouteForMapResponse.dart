import 'dart:convert';

GetRouteForMapResponse getRouteForMapResponseFromJson(String str) => GetRouteForMapResponse.fromJson(json.decode(str));

String getRouteForMapResponseToJson(GetRouteForMapResponse data) => json.encode(data.toJson());
class GetRouteForMapResponse {
  int? status;
  UserhelprequestRoute? userhelprequest;
  UserhelpacceptRoute? userhelpaccept;

  GetRouteForMapResponse(
      {this.status, this.userhelprequest, this.userhelpaccept});

  GetRouteForMapResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userhelprequest = json['userhelprequest'] != null
        ? new UserhelprequestRoute.fromJson(json['userhelprequest'])
        : null;
    userhelpaccept = json['userhelpaccept'] != null
        ? new UserhelpacceptRoute.fromJson(json['userhelpaccept'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.userhelprequest != null) {
      data['userhelprequest'] = this.userhelprequest!.toJson();
    }
    if (this.userhelpaccept != null) {
      data['userhelpaccept'] = this.userhelpaccept!.toJson();
    }
    return data;
  }
}

class UserhelprequestRoute {
  int? id;
  String? fromDevId;
  String? fromDevToken;
  String? toDevId;
  String? toDevToken;
  int? fromUserId;
  int? toUserId;
  int? helptype;
  String? fromDevType;
  String? toDevType;
  double? fromLat;
  double? fromLong;
  double? toLat;
  double? toLong;
  String? fromAddress;
  String? toAddress;
  int? ishelpaccepted;
  String? sendername;
  String? senderemail;
  String? sendermobile;
  String? createdAt;
  String? updatedAt;

  UserhelprequestRoute(
      {this.id,
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
        this.ishelpaccepted,
        this.sendername,
        this.senderemail,
        this.sendermobile,
        this.createdAt,
        this.updatedAt});

  UserhelprequestRoute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromDevId = json['from_dev_id'];
    fromDevToken = json['from_dev_token'];
    toDevId = json['to_dev_id'];
    toDevToken = json['to_dev_token'];
    fromUserId = json['from_user_id'];
    toUserId = json['to_user_id'];
    helptype = json['helptype'];
    fromDevType = json['from_Dev_type'];
    toDevType = json['to_dev_Type'];
    fromLat = json['from_lat'];
    fromLong = json['from_long'];
    toLat = json['to_lat'];
    toLong = json['to_long'];
    fromAddress = json['from_Address'];
    toAddress = json['to_Address'];
    ishelpaccepted = json['ishelpaccepted'];
    sendername = json['sendername'];
    senderemail = json['senderemail'];
    sendermobile = json['sendermobile'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from_dev_id'] = this.fromDevId;
    data['from_dev_token'] = this.fromDevToken;
    data['to_dev_id'] = this.toDevId;
    data['to_dev_token'] = this.toDevToken;
    data['from_user_id'] = this.fromUserId;
    data['to_user_id'] = this.toUserId;
    data['helptype'] = this.helptype;
    data['from_Dev_type'] = this.fromDevType;
    data['to_dev_Type'] = this.toDevType;
    data['from_lat'] = this.fromLat;
    data['from_long'] = this.fromLong;
    data['to_lat'] = this.toLat;
    data['to_long'] = this.toLong;
    data['from_Address'] = this.fromAddress;
    data['to_Address'] = this.toAddress;
    data['ishelpaccepted'] = this.ishelpaccepted;
    data['sendername'] = this.sendername;
    data['senderemail'] = this.senderemail;
    data['sendermobile'] = this.sendermobile;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class UserhelpacceptRoute {
  int? id;
  String? acceptedDevId;
  String? acceptedDevToken;
  int? acceptedUserId;
  int? helptype;
  double? lat;
  double? long;
  String? address;
  int? ishelpaccepted;
  int? helprequestid;
  String? recevierid;
  String? receivername;
  String? receiveremail;
  String? receivermobile;
  String? createdAt;
  String? updatedAt;

  UserhelpacceptRoute(
      {this.id,
        this.acceptedDevId,
        this.acceptedDevToken,
        this.acceptedUserId,
        this.helptype,
        this.lat,
        this.long,
        this.address,
        this.ishelpaccepted,
        this.helprequestid,
        this.recevierid,
        this.receivername,
        this.receiveremail,
        this.receivermobile,
        this.createdAt,
        this.updatedAt});

  UserhelpacceptRoute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    acceptedDevId = json['accepted_dev_id'];
    acceptedDevToken = json['accepted_dev_token'];
    acceptedUserId = json['accepted_user_id'];
    helptype = json['helptype'];
    lat = json['lat'];
    long = json['long'];
    address = json['Address'];
    ishelpaccepted = json['ishelpaccepted'];
    helprequestid = json['helprequestid'];
    recevierid = json['recevierid'];
    receivername = json['receivername'];
    receiveremail = json['receiveremail'];
    receivermobile = json['receivermobile'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accepted_dev_id'] = this.acceptedDevId;
    data['accepted_dev_token'] = this.acceptedDevToken;
    data['accepted_user_id'] = this.acceptedUserId;
    data['helptype'] = this.helptype;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['Address'] = this.address;
    data['ishelpaccepted'] = this.ishelpaccepted;
    data['helprequestid'] = this.helprequestid;
    data['recevierid'] = this.recevierid;
    data['receivername'] = this.receivername;
    data['receiveremail'] = this.receiveremail;
    data['receivermobile'] = this.receivermobile;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

