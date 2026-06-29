import 'package:flutter/material.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:deacon_school_admin/Core/unit/unit.dart';


class ErrorMsgCustom extends StatelessWidget {
  final String msg;
  const ErrorMsgCustom({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: ColorData.danger75Color,
            size: Unit(context).getWidthSize*0.042,
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Text(msg,style: StyleData.textStyleDanger75TextColorR14,),
          ),
        ],
      ),
    );
  }
}