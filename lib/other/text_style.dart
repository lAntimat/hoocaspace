import 'package:flutter/material.dart';
import 'package:hoocaspace/other/color_constants.dart';

class TextStyleConst {
  static final baseTextStyle = const TextStyle(
    fontFamily: 'Poppins'
  );
  static final smallTextStyle = commonTextStyle.copyWith(
    fontSize: 9.0,
  );
  static final commonTextStyle = baseTextStyle.copyWith(
      color: const Color(0xffb6b2df),
    fontSize: 14.0,
      fontWeight: FontWeight.w400
  );
  static final titleTextStyle = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.w600
  );

  static final subTitleTextStyle = baseTextStyle.copyWith(
      color: ColorConstants.secondWhite,
      fontSize: 14.0,
      fontWeight: FontWeight.w500
  );
  static final headerTextStyle = baseTextStyle.copyWith(
    color: Colors.white,
    fontSize: 20.0,
    fontWeight: FontWeight.w400
  );
}