import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mhw_quest_book/utility/fonts/fonts.dart';

class TextAppStyle {
  static TextStyle textsBodyLarge({Color color = Colors.black}) => TextStyle(
        fontSize: 16,
        fontFamily: AppFont.Khaitun,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle textsBodyLargeProminent({Color color = Colors.black}) =>
      TextStyle(
        fontSize: 16,
        fontFamily: AppFont.Khaitun,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle textsHeaderLargeProminent({Color color = Colors.black}) =>
      TextStyle(
        fontSize: 18,
        fontFamily: AppFont.Khaitun,
        fontWeight: FontWeight.w500,
        height: 0.10,
        color: color,
      );

  static TextStyle textsBodySuperLargeProminent({Color color = Colors.black}) =>
      TextStyle(
        fontSize: 42,
        fontFamily: AppFont.Khaitun,
        fontWeight: FontWeight.w900,
        color: color,
      );

  static TextStyle textsBodyExtraSmall({Color color = Colors.black}) =>
      TextStyle(
        fontSize: 10,
        fontFamily: AppFont.Khaitun,
        fontWeight: FontWeight.w400,
        //height: 0.14,
        color: color,
      );

  static TextStyle textsBodyMedium({Color color = Colors.black}) => TextStyle(
        fontSize: 14,
        fontFamily: AppFont.Khaitun,
        fontWeight: FontWeight.w400,
        //height: 0.11,
        color: color,
      );

  static TextStyle textsBodyMediumProminent({Color color = Colors.black}) =>
      TextStyle(
        fontSize: 14,
        fontFamily: AppFont.Khaitun,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle textsBodySmall({Color color = Colors.black}) => TextStyle(
        fontSize: 12,
        fontFamily: AppFont.Khaitun,
        fontWeight: FontWeight.w400,
        color: color,
      );
}
