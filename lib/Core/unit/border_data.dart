import 'package:flutter/material.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/size_data.dart';
import 'package:deacon_school_admin/Core/unit/unit.dart';

abstract class BorderData {

  static Unit? unit;
  static init(BuildContext context) {
    unit = Unit(context);
  }

  /*static InputBorder outlineInputBorderPrimary25W0R8 = OutlineInputBorder(
    borderSide: BorderSide(
        width: 0,
        color: ColorData.primaryColor25
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s8),
  );
  static InputBorder outlineInputBorderPrimary200W1R8 = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.primaryColor200,
      width: unit!.width(SizeData.s1),
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s8),
  );
  static InputBorder outlineInputBorderPrimary500W1R8 = OutlineInputBorder(
    borderSide: BorderSide(
        width: unit!.width(SizeData.s1),
        color: ColorData.primaryColor500
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s8),
  );
  static InputBorder outlineInputBorderPrimary600W1R8 = OutlineInputBorder(
    borderSide: BorderSide(
        width: unit!.width(SizeData.s1),
        color: ColorData.primaryColor600
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s8),
  );
  static InputBorder outlineInputBorderPrimary700W1R8 = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.primaryColor700,
      width: unit!.width(SizeData.s1),
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s8),
  );

  static InputBorder outlineInputBorderGray25W0R8 = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.grayColor25,
      width: unit!.width(0),
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s8),
  );
  static InputBorder outlineInputBorderGray200W1R8 = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.grayColor200,
      width: unit!.width(SizeData.s1),
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s8),
  );
  static InputBorder outlineInputBorderGray200W1R5 = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.grayColor200,
      width: unit!.width(SizeData.s1),
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s5),
  );
  static InputBorder outlineInputBorderGray700W1R8 = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.grayColor700,
      width: unit!.width(SizeData.s1),
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s8),
  );

  static InputBorder outlineInputBorderBlue300W1R8 = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.blueColor300,
      width: unit!.width(SizeData.s1),
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s8),
  );

  static InputBorder outlineInputBorderDanger400W1R8 = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.dangerColor400,
      width: unit!.width(SizeData.s1),
    ),
    borderRadius:
    BorderRadius.circular(SizeData.s8),
  );

  static InputBorder outlineInputBorderWhite200W1R6 = OutlineInputBorder(
      borderSide: BorderSide(
        color: ColorData.whiteColor200,
        width: unit!.width(SizeData.s1),
      ),
      borderRadius: BorderRadius.circular(SizeData.s6)
  );

  static InputBorder underlineInputBorderGray200W1R0 = UnderlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.grayColor200,
      width: unit!.width(SizeData.s1),
    ),
  );

  static InputBorder underlineInputBorderBlue300W1R0 = UnderlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.blueColor400,
      width: unit!.width(SizeData.s1),
    ),
  );

  static InputBorder underlineInputBorderDanger400W1R0 = UnderlineInputBorder(
    borderSide: BorderSide(
      color: ColorData.dangerColor400,
      width: unit!.width(SizeData.s1),
    ),
  );*/
}