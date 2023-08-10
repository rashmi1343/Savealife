import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:savealifedemoapp/ui/Signup/Validation/validation_item.dart';

class ValidationProvider with ChangeNotifier {
  ValidationItem _name = ValidationItem(null, null);
  ValidationItem _email = ValidationItem(null, null);
  ValidationItem _mobile = ValidationItem(null, null);
  ValidationItem _password = ValidationItem(null, null);
  ValidationItem _address = ValidationItem(null, null);

  // ValidationItem _city = ValidationItem(null, null);
  // ValidationItem _country = ValidationItem(null, null);
  ValidationItem _pincode = ValidationItem(null, null);

  //Getters

  ValidationItem get name => _name;

  ValidationItem get email => _email;

  ValidationItem get mobile => _mobile;

  ValidationItem get password => _password;

  ValidationItem get address => _address;

  ValidationItem get pincode => _pincode;

  bool get isValid {
    if (_name.value!.isNotEmpty &&
        _email.value!.isNotEmpty &&
        _mobile.value!.isNotEmpty&&
        _password.value!.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Setters

  String? validateName(String value) {
    if (value.length >= 6) {
      _name = ValidationItem(value, null);
    } else {
      _name =
          ValidationItem(null, "User Name must be at least 6 characters");
    }
    notifyListeners();
    return null;
  }

  String? validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      _email = ValidationItem(value, "Email field is required");
    } else if (!regExp.hasMatch(value)) {
      _email = ValidationItem(value, "Please enter a valid email address");
    }
    // success condition
    else {
      _email = ValidationItem(value, null);
    }
    notifyListeners();
    return null;
  }

  String? validateMobileNumber(String value) {
    String pattern = r'(^[0-9]*$)';

    RegExp regExp = RegExp(pattern);

    if (value.isEmpty) {
      _mobile = ValidationItem(value, "Please enter mobile number!");
    } else if (value.length != 10) {
      _mobile = ValidationItem(value, "Mobile Number must be of 10 digits!");
    } else if (!regExp.hasMatch(value)) {
      _mobile = ValidationItem(value, "Please enter a valid mobile number!");
    }
    // success condition
    else {
      _mobile = ValidationItem(value, null);
    }
    notifyListeners();
    return null;
  }

  String? validatePassword(String value) {
    if (value.length >= 6) {
      _password = ValidationItem(value, null);
    } else {
      _password =
          ValidationItem(null, "Password must be greater than 6 characters!");
    }

    notifyListeners();
    return null;
  }

  String? validatePincode(String value) {
    //  String pattern = r'^[1-9]{3}\s{0,1}[0-9]{3}$';
    //  String pattern = r'^[1-9]{1}[0-9]{2}\\s{0,1}[0-9]{3}$';
    String pattern = r'([0-9]{6}|[0-9]{3}\s[0-9]{3})'; //for postal code
    String addresspattern =
        r'\A (\d+ [a-zA-Z] {0,1}\s {0,1} [-] {1}\s {0,1}\d* [a-zA-Z] {0,1}|\d+ [a-zA-Z-] {0,1}\d* [a-zA-Z] {0,1})\s*+ (.*)'; //for address
    String addresspattern2 =
        r'^[0-9]+\s+([a-zA-Z]+|[a-zA-Z]+\s[a-zA-Z]+)$'; //for address

    RegExp regExp = RegExp(pattern);

    if (value.length >= 6) {
      _pincode = ValidationItem(value, null);
    } else if (!regExp.hasMatch(value)) {
      _pincode = ValidationItem(value, "Pincode must be of 6 digits!");
    } else {
      _pincode = ValidationItem(value, null);
    }
    notifyListeners();
    return null;
  }
  // String? validateAddress(String? value) {
  //   if (value!.isEmpty) {
  //     return "Address is Required!";
  //   } else if (value.trim().length < 7) {
  //     return "Address must be at least 7 characters in length!";
  //   }
  //   notifyListeners();
  //   return null;
  // }
  String? validateAddress(String value) {
    String addresspattern =
        r'\A (\d+ [a-zA-Z] {0,1}\s {0,1} [-] {1}\s {0,1}\d* [a-zA-Z] {0,1}|\d+ [a-zA-Z-] {0,1}\d* [a-zA-Z] {0,1})\s*+ (.*)'; //for address
    String addresspattern2 =
        r'^[0-9]+\s+([a-zA-Z]+|[a-zA-Z]+\s[a-zA-Z]+)$'; //for address

    RegExp regExp = RegExp(addresspattern2);


    if (value.length >= 6) {
      _address = ValidationItem(value, null);
    } else if(!regExp.hasMatch(value)){
      _address =
          ValidationItem(null, "Address must be greater than 6 characters!");
    }
    else{
      _address=ValidationItem(value, null);
    }


    notifyListeners();
    return null;
  }

  void sumbitData() {
    print(
        "UserName:${name.value},Email:${email.value},Mobile:${mobile.value},Password:${password.value}");
  }
}
