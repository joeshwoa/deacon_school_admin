import 'package:deacon_school_admin/Core/unit/size_data.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';

class LoadingAppCustom extends StatelessWidget {

  final double size;
  const LoadingAppCustom({super.key, this.size = 65});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size,
        width: size,
        child: LoadingAnimationWidget.halfTriangleDot(
          color: ColorData.primaryLightColor,
          size: size,
        ),
      ),
    );
  }
}
