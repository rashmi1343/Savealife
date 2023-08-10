import 'package:flutter/material.dart';


class FontName {
  static const poppinsLight = "PoppinsLight";
  static const poppinsRegular = "PoppinsRegular";
  static const poppinsMedium = "PoppinsMedium";
  static const poppinsSemiBold = "PoppinsSemiBold";
  static const poppinsBold = "PoppinsBold";
}

class CustomTextStyle {
  static const TextStyle textfieldPlaceholderTextStyle =
  TextStyle(fontSize: 14, fontFamily: FontName.poppinsRegular);
  static const TextStyle textfieldTitleTextStyle = TextStyle(
      fontSize: 15,
      fontFamily: FontName.poppinsSemiBold,
      color: Color(0xff243444));

  static const TextStyle homedashboardlist = TextStyle(
      fontSize: 15,
      color: Color(0xff111111),
      fontWeight: FontWeight.normal,
      fontFamily: FontName.poppinsSemiBold);
}