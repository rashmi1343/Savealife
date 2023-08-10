import 'dart:convert';

SignUpErrorResponse signUpErrorResponseFromJson(String str) => SignUpErrorResponse.fromJson(json.decode(str));

String signUpErrorResponseToJson(SignUpErrorResponse data) => json.encode(data.toJson());

class SignUpErrorResponse {
  SignUpErrorResponse({
    required this.status,
  });

  Status status;

  factory SignUpErrorResponse.fromJson(Map<String, dynamic> json) => SignUpErrorResponse(
    status: Status.fromJson(json["status"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status.toJson(),
  };
}

class Status {
  Status({
    required this.name,
    required this.errors,
  });

  String name;
  List<SignUpErrors> errors;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    name: json["name"],
    errors: List<SignUpErrors>.from(json["errors"].map((x) => SignUpErrors.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "errors": List<dynamic>.from(errors.map((x) => x.toJson())),
  };
}

class SignUpErrors {
  SignUpErrors({
    required this.message,
    required this.type,
    required this.path,
    required this.value,
    required this.origin,
    required this.instance,
    required this.validatorKey,
    required this.validatorName,
    required this.validatorArgs,
    required this.original,
  });

  String message;
  String type;
  String path;
  String value;
  String origin;
  Instance instance;
  String validatorKey;
  String validatorName;
  List<dynamic> validatorArgs;
  Original original;

  factory SignUpErrors.fromJson(Map<String, dynamic> json) => SignUpErrors(
    message: json["message"],
    type: json["type"],
    path: json["path"],
    value: json["value"],
    origin: json["origin"],
    instance: Instance.fromJson(json["instance"]),
    validatorKey: json["validatorKey"],
    validatorName: json["validatorName"] == null ? null : json["validatorName"],
    validatorArgs: List<dynamic>.from(json["validatorArgs"].map((x) => x)),
    original: Original.fromJson(json["original"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "type": type,
    "path": path,
    "value": value,
    "origin": origin,
    "instance": instance.toJson(),
    "validatorKey": validatorKey,
    "validatorName": validatorName == null ? null : validatorName,
    "validatorArgs": List<dynamic>.from(validatorArgs.map((x) => x)),
    "original": original.toJson(),
  };
}

class Instance {
  Instance({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.updatedAt,
    required this.createdAt,
  });

  dynamic id;
  String username;
  String email;
  String password;
  DateTime updatedAt;
  DateTime createdAt;

  factory Instance.fromJson(Map<String, dynamic> json) => Instance(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    password: json["password"],
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "password": password,
    "updatedAt": updatedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
  };
}

class Original {
  Original({
    required this.validatorName,
    required this.validatorArgs,
  });

  String validatorName;
  List<dynamic>? validatorArgs;

  factory Original.fromJson(Map<String, dynamic> json) => Original(
    validatorName: json["validatorName"] == null ? null : json["validatorName"],
    validatorArgs: json["validatorArgs"] == null ? null : List<dynamic>.from(json["validatorArgs"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "validatorName": validatorName == null ? null : validatorName,
    "validatorArgs": validatorArgs == null ? null : List<dynamic>.from(validatorArgs!.map((x) => x)),
  };
}
