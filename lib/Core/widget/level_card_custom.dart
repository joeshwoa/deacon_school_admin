import 'package:deacon_school_admin/Core/unit/app_routes.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LevelCardCustom extends StatelessWidget {
  const LevelCardCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRouter.kLevelScreenView);
      },
      child: Container(
        decoration: BoxDecoration(
            color: ColorData.secondaryBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: ColorData.primaryBorderColor,
                width: 1
            )
        ),
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorData.success25Color,
                border: Border.all(color: ColorData.success50Color)
              ),
              clipBehavior: Clip.antiAlias,
              child: Center(
                child: Text(
                  '1',
                  textDirection: TextDirection.rtl,
                  style: StyleData.textStyleSuccessTextColorB30,
                ),
              ),
            ),
            const Gap(10),
            Text(
              'مستوي اول',
              textDirection: TextDirection.rtl,
              style: StyleData.textStyleBlackTextColorSB20,
            ),
            Spacer(),
            Text(
              '12 ',
              textDirection: TextDirection.rtl,
              style: StyleData.textStyleBlackTextColorSB16,
            ),
          ],
        ),
      ),
    );
  }
}