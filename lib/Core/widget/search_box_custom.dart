import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:deacon_school_admin/Core/widget/church_melody_card_custom.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchBoxCustom extends StatelessWidget {
  const SearchBoxCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.76,
      height: 350,
      child: Material(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          topLeft: Radius.circular(0),
        ),
        child: Container(
          padding: EdgeInsets.all(8),

          width: MediaQuery.of(context).size.width*0.76,
          height: 350,
          decoration: BoxDecoration(
              color: ColorData.whiteColor,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                topLeft: Radius.circular(0),
              ),
              border: Border.all(
                color: ColorData.primaryColor,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF000000).withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 4,
                )
              ]
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: TextField(
                          style: StyleData.textStylePrimaryTextColorSB16,
                          decoration: InputDecoration(
                            hintText: 'بحث',
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
                      ),
                    ),
                  ),
                  const Gap(8),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorData.primaryLightColor,
                    ),
                    child: Icon(Icons.search_rounded, color: ColorData.whiteColor),
                  )
                ],
              ),
              const Gap(8),
              Expanded(
                child: ListView(
                  children: [
                    ChurchMelodyCardCustom(),
                    ChurchMelodyCardCustom(),
                    ChurchMelodyCardCustom()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
