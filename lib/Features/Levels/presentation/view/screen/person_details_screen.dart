import 'package:deacon_school_admin/Core/helper/cache_image.dart';
import 'package:deacon_school_admin/Core/unit/app_routes.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:deacon_school_admin/Core/widget/person_card_custom.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PersonDetailsScreen extends StatelessWidget {
  const PersonDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorData.whiteColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppBar(
            backgroundColor: ColorData.whiteColor,toolbarHeight: 70,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: ColorData.primaryColor),
              onPressed: () {
                context.pop();
              },
            ),
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
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 210,
                    width: 210,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CacheImageCustom(image: 'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=740&t=st=1725614724~exp=1725615324~hmac=a601f37153a4854da459f2df696226908a4c860a2cffc29a9307c511400c88cc',),
                    ),

                  ),
                ],
              ),
              Gap(20),
              TextField(
                controller: TextEditingController(text: 'بافلي ايمن'),
                enabled: false,
                style: StyleData.textStylePrimaryTextColorSB16,
                decoration: InputDecoration(
                  labelText: 'الاسم',
                  labelStyle: StyleData.textStylePrimary60TextColorSB16,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primaryLightColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primary60Color),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primaryColor),
                  ),
                ),
              ),
              Gap(20),
              TextField(
                controller: TextEditingController(text: '01211899128'),
                enabled: false,
                style: StyleData.textStylePrimaryTextColorSB16,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  labelStyle: StyleData.textStylePrimary60TextColorSB16,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primaryLightColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primary60Color),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primaryColor),
                  ),
                ),
              ),
              Gap(20),
              TextField(
                controller: TextEditingController(text: '01211899128'),
                enabled: false,
                style: StyleData.textStylePrimaryTextColorSB16,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف ولي الامر',
                  labelStyle: StyleData.textStylePrimary60TextColorSB16,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primaryLightColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primary60Color),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primaryColor),
                  ),
                ),
              ),
              Gap(20),
              TextField(
                controller: TextEditingController(text: 'مستوي رابع'),
                enabled: false,
                style: StyleData.textStylePrimaryTextColorSB16,
                decoration: InputDecoration(
                  labelText: 'المستوي',
                  labelStyle: StyleData.textStylePrimary60TextColorSB16,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primaryLightColor),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primary60Color),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorData.primaryColor),
                  ),
                ),
              ),
              Gap(20),
              GestureDetector(
                onTap: () {
                  bool logout = true;
                  if(logout) {
                    /*context.go(AppRouter.kLoginView);*/
                  }
                },
                child: Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: ColorData.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                        'تسجيل خروج',
                        style: StyleData.textStyleDanger75TextColorM18
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
