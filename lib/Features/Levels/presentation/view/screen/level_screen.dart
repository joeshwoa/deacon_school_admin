import 'package:deacon_school_admin/Core/helper/cache_image.dart';
import 'package:deacon_school_admin/Core/unit/app_routes.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:deacon_school_admin/Core/widget/person_card_custom.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorData.whiteColor,
        appBar: AppBar(
          backgroundColor: ColorData.whiteColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: ColorData.primaryColor),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            'المستوي الاول',
            textDirection: TextDirection.rtl,
            style: StyleData.textStyleBlackTextColorSB22,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              PersonCardCustom(),
              PersonCardCustom(),
              PersonCardCustom(),
              PersonCardCustom(),
              PersonCardCustom(),
              PersonCardCustom(),
              PersonCardCustom(),
              PersonCardCustom(),
              PersonCardCustom(),
            ],
          ),
        ),
      ),
    );
  }
}
