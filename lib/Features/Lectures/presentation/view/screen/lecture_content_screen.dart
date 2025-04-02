import 'package:deacon_school_admin/Core/unit/app_routes.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LectureContentScreen extends StatelessWidget {
  const LectureContentScreen({super.key});

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
            'بصالتس',
            textDirection: TextDirection.rtl,
            style: StyleData.textStyleBlackTextColorSB22,
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: GestureDetector(
                onTap: () {
                  // TODO: download audio and pdf
                },
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                      color: ColorData.secondaryBackgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: ColorData.primaryBorderColor,
                          width: 1
                      )
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Icon(
                    Icons.mode_edit_rounded,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'يقال في الفترة كذا من السنة ......',
                textDirection: TextDirection.rtl,
                style: StyleData.textStyleBlackTextColorSB22,
                textAlign: TextAlign.right,
                maxLines: 10,
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  context.push(AppRouter.kLecturePDFScreenView);
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          color: ColorData.primaryColor
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Icon(Icons.picture_as_pdf_rounded, size: 30, color: ColorData.whiteColor,),
                      ),
                      const Gap(10),
                      Text(
                        'نص اللحن',
                        textDirection: TextDirection.rtl,
                        style: StyleData.textStyleBlackTextColorSB16,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              const Gap(8),
              GestureDetector(
                onTap: () {
                  context.push(AppRouter.kAudioPlayerScreenView);
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: ColorData.primaryColor
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Icon(Icons.audio_file_rounded, size: 30, color: ColorData.whiteColor,),
                      ),
                      const Gap(10),
                      Text(
                        'اللحن مسموع',
                        textDirection: TextDirection.rtl,
                        style: StyleData.textStyleBlackTextColorSB16,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }
}
