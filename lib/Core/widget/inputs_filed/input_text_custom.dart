/*
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:deacon_school_admin/Core/translations/locale_keys.g.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/size_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:deacon_school_admin/Core/unit/unit.dart';

class InputTextCustom extends StatelessWidget {
  bool? obscureText;
  final TextEditingController controller;
  final String hintText;
  TextInputType? textInputType;
  String? Function(String?)? validator;

  IconData? suffixIcon;
  Function()? onPressSuffixIcon;
  void Function()? onEditingComplete;
  FocusNode? focusNode;
  int ? minLines;
  Color ? color;
  Widget ? prefix;
  bool ? enabled;
  void Function(String)? onChanged;

  InputTextCustom({Key? key,this.obscureText, required this.controller, required this.hintText , this.textInputType,this.validator,
    this.color, this.suffixIcon, this.minLines, this.prefix, this.enabled,this.onChanged,
    this.onPressSuffixIcon, this.onEditingComplete, this.focusNode,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Placeholder()*/
/*TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      obscureText: obscureText??false,
      keyboardType: textInputType??TextInputType.text,
      maxLines: minLines??1,
      onChanged: onChanged,

      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: StyleData.textStyleGray400M12.copyWith(
            fontSize: Unit(context).getWidthSize*0.037,
            color: ColorData.grayColor400
        ),
        suffixIcon: suffixIcon!=null ?
        IconButton(
            onPressed: onPressSuffixIcon,
            icon: Icon(suffixIcon)) : null,
        filled: true,
        fillColor: color??ColorData.whiteColor200,
        prefixIcon: prefix,
        enabled: enabled??true,
        contentPadding: EdgeInsets.all(SizeData.s10),

        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorData.grayColor200,
          ),
          borderRadius: BorderRadius.circular(SizeData.s8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorData.grayColor200,),
          borderRadius: BorderRadius.circular(SizeData.s8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorData.primaryColor700,),
          borderRadius: BorderRadius.circular(SizeData.s8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorData.dangerColor400,),
          borderRadius: BorderRadius.circular(SizeData.s8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorData.dangerColor400,),
          borderRadius: BorderRadius.circular(SizeData.s8),
        ),
      ),
      validator: validator??(value) {
        if (value!.isEmpty) {
          return '';//LocaleKeys.kPleaseFillThisField.tr();
        }
        return null;
      },
    )*//*
;
  }
}
*/
