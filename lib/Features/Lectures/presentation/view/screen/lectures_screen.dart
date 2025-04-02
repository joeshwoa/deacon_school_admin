import 'package:deacon_school_admin/Core/helper/cache_image.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:deacon_school_admin/Core/unit/unit.dart';
import 'package:deacon_school_admin/Core/widget/church_melody_card_custom.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LecturesScreen extends StatelessWidget {
  const LecturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        Text(
          'الحان الكنيسة',
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
          child: CacheImageCustom(image: 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjwI6DjW5fE3XCCphxkfgmX9w1erwnYoPx8lSqUmP0VcCUXnoZAyoseaNXR-u5_3BUn__zuMeZ0so82rQjVI2EEFHUNioE4HoB8Bio1K8ONYguOdmumnNwiS-DXOwCDZApMwdRfAgnM_gBu/s1600/1902765_584695021615038_852258775_n.jpg',),
        ),
        const Gap(8),
        ChurchMelodyCardCustom(),
        ChurchMelodyCardCustom(),
        ChurchMelodyCardCustom(),
        ChurchMelodyCardCustom(),
        ChurchMelodyCardCustom(),
        ChurchMelodyCardCustom(),
        ChurchMelodyCardCustom(),
        ChurchMelodyCardCustom(),
        ChurchMelodyCardCustom(),
      ],
    );
  }
}
