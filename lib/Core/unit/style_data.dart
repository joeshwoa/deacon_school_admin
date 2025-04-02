import 'package:flutter/material.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/font_weiget_data.dart';
import 'package:deacon_school_admin/Core/unit/size_data.dart';
import 'package:deacon_school_admin/Core/unit/unit.dart';


abstract class StyleData {

  static const fontFamily='ArefRuqaa';

  static Unit? unit;
  static init(BuildContext context) {
    unit = Unit(context);
  }

  static TextStyle textStyleBlackTextColorSB12 = TextStyle(
    color: ColorData.blackColor,
    fontWeight: FontWeightStyles.semiBold,
    fontSize: 12,
    height: 0.0,
    fontFamily: fontFamily,
  );
  static TextStyle textStyleBlackTextColorSB16 = TextStyle(
    color: ColorData.blackColor,
    fontWeight: FontWeightStyles.semiBold,
    fontSize: 16,
    height: 0.0,
    fontFamily: fontFamily,
  );
  static TextStyle textStyleBlackTextColorM16 = TextStyle(
    color: ColorData.blackColor,
    fontWeight: FontWeightStyles.medium,
    fontSize: 16,
    height: 0.0,
    fontFamily: fontFamily,
  );
  static TextStyle textStyleBlackTextColorM20 = TextStyle(
    color: ColorData.blackColor,
    fontWeight: FontWeightStyles.medium,
    fontSize: 20,
    height: 0.0,
    fontFamily: fontFamily,
  );
  static TextStyle textStyleBlackTextColorSB20 = TextStyle(
    color: ColorData.blackColor,
    fontWeight: FontWeightStyles.semiBold,
    fontSize: 20,
    height: 0.0,
    fontFamily: fontFamily,
  );
  static TextStyle textStyleBlackTextColorSB22 = TextStyle(
    color: ColorData.blackColor,
    fontWeight: FontWeightStyles.semiBold,
    fontSize: 22,
    height: 0.0,
    fontFamily: fontFamily,
  );
  static TextStyle textStyleBlackTextColorSB30 = TextStyle(
    color: ColorData.blackColor,
    fontWeight: FontWeightStyles.semiBold,
    fontSize: 30,
    height: 0.0,
    fontFamily: fontFamily,
  );
  static TextStyle textStyleBlackTextColorB40 = TextStyle(
    color: ColorData.blackColor,
    fontWeight: FontWeightStyles.bold,
    fontSize: 40,
    height: 0.0,
    fontFamily: fontFamily,
  );
  static TextStyle textStyleBlackTextColorB24 = TextStyle(
    color: ColorData.blackColor,
    fontWeight: FontWeightStyles.bold,
    fontSize: 24,
    height: 0.0,
    fontFamily: fontFamily,
  );

  static TextStyle textStyleWhiteTextColorSB30 = TextStyle(
    color: ColorData.whiteColor,
    fontWeight: FontWeightStyles.semiBold,
    fontSize: 30,
    height: 0.0,
    fontFamily: fontFamily,
  );
  static TextStyle textStyleWhiteTextColorM18 = TextStyle(
    color: ColorData.whiteColor,
    fontWeight: FontWeightStyles.medium,
    fontSize: 18,
    height: 0.0,
    fontFamily: fontFamily,
  );

  static TextStyle textStyleSuccessTextColorB30 = TextStyle(
    color: ColorData.successColor,
    fontWeight: FontWeightStyles.bold,
    fontSize: 30,
    height: 0.0,
    fontFamily: fontFamily,
  );

  static TextStyle textStyleDanger75TextColorR14 = TextStyle(
    color: ColorData.danger75Color,
    fontWeight: FontWeightStyles.regular,
    fontSize: 14,
    height: 0.0,
    fontFamily: fontFamily,
  );
  static TextStyle textStyleDanger75TextColorM18 = TextStyle(
    color: ColorData.danger75Color,
    fontWeight: FontWeightStyles.medium,
    fontSize: 18,
    height: 0.0,
    fontFamily: fontFamily,
  );

  static TextStyle textStylePrimary60TextColorSB16 = TextStyle(
    color: ColorData.primary60Color,
    fontWeight: FontWeightStyles.semiBold,
    fontSize: 16,
    height: 0.0,
    fontFamily: fontFamily,
  );

  static TextStyle textStylePrimaryTextColorSB16 = TextStyle(
    color: ColorData.primaryColor,
    fontWeight: FontWeightStyles.semiBold,
    fontSize: 16,
    height: 0.0,
    fontFamily: fontFamily,
  );
}
