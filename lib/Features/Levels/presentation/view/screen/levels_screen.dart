import 'package:deacon_school_admin/Core/cubit/layout_cubit.dart';
import 'package:deacon_school_admin/Core/helper/cache_image.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:deacon_school_admin/Core/unit/unit.dart';
import 'package:deacon_school_admin/Core/widget/level_card_custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        Text(
          'المستويات',
          textDirection: TextDirection.rtl,
          style: StyleData.textStyleBlackTextColorSB30,
        ),
        const Gap(10),
        Container(
          height: 220,
          width: Unit(context).getWidthSize,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24)
          ),
          clipBehavior: Clip.antiAlias,
          child: CacheImageCustom(image: 'https://i.pinimg.com/236x/90/75/45/907545f182336d711f32f4599a293d8f.jpg',),
        ),
        const Gap(8),
        LevelCardCustom(),
        LevelCardCustom(),
        LevelCardCustom(),
        LevelCardCustom(),
      ],
    );
  }
}
