import 'package:deacon_school_admin/Core/helper/cache_image.dart';
import 'package:deacon_school_admin/Core/unit/app_routes.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PersonCardCustom extends StatelessWidget {
  const PersonCardCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRouter.kPersonDetailsScreenView);
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
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CacheImageCustom(image: 'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=740&t=st=1725614724~exp=1725615324~hmac=a601f37153a4854da459f2df696226908a4c860a2cffc29a9307c511400c88cc',),
              ),

            ),
            const Gap(24),
            Text(
              'مينا ايمن',
              textDirection: TextDirection.rtl,
              style: StyleData.textStyleBlackTextColorSB22,
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}