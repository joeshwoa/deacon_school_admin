import 'package:flutter/material.dart';
import 'package:deacon_school_admin/Core/unit/size_data.dart';

class MainButtonCustom extends StatelessWidget {

  final Function() onTap;
  final Color? color;
  final String text;
  final TextStyle textStyle;
  final Border? border;
  final bool loading;
  final Color? loadingColor;
  final double? height;
  const MainButtonCustom({super.key, required this.onTap, this.color, required this.text, required this.textStyle, this.border, this.loading = false, this.loadingColor, this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeData.s4),
      child: GestureDetector(
        onTap: !loading ? onTap : () {},
        child: Container(
          padding: EdgeInsets.all(SizeData.s12),
          constraints: height != null ? BoxConstraints(
            minHeight: height!,
          ) : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeData.s8),
            color: color,
            border: border,
          ),
          child: loading ? Center(
            child: CircularProgressIndicator(
              color: loadingColor,
            ),
          ) : Center(
            child: Text(
              text,
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }
}
