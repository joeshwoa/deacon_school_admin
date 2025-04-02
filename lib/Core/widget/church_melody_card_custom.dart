import 'package:deacon_school_admin/Core/unit/app_routes.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:deacon_school_admin/generated/assets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ChurchMelodyCardCustom extends StatelessWidget {
  const ChurchMelodyCardCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(AppRouter.kLectureContentScreenView);
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
                  borderRadius: BorderRadius.circular(12)
              ),
              clipBehavior: Clip.antiAlias,
              child: Image(image: AssetImage(Assets.imageChurchMelodyIcon),),
            ),
            const Gap(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'بصالتس',
                  textDirection: TextDirection.rtl,
                  style: StyleData.textStyleBlackTextColorSB16,
                ),
                const Gap(8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(AppRouter.kAudioPlayerScreenView);
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorData.primaryColor,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Builder(
                            builder: (context) {
                              return Icon(
                                Icons.play_arrow_rounded,
                                color: ColorData.whiteColor,
                                size: 18,
                              );
                            }
                        ),
                      ),
                    ),
                    const Gap(8),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: ColorData.primaryBorderColor,
                              width: 1
                          )
                      ),
                      padding: EdgeInsets.all(8),
                      child: Text(
                        '10:12',
                        textDirection: TextDirection.rtl,
                        style: StyleData.textStyleBlackTextColorSB12,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {

              },
              icon: Icon(
                Icons.mode_edit_rounded,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
