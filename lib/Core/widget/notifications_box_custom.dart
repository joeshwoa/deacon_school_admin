import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:deacon_school_admin/Core/widget/church_melody_card_custom.dart';
import 'package:deacon_school_admin/Core/widget/notification_card_custom.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationsBoxCustom extends StatelessWidget {
  const NotificationsBoxCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.86,
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

          width: MediaQuery.of(context).size.width*0.86,
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
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: ColorData.secondaryBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: ColorData.primaryBorderColor,
                        width: 1
                    )
                ),
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اضافة اشعار جديد',
                            textDirection: TextDirection.rtl,
                            style: StyleData.textStyleBlackTextColorSB16,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    IconButton(
                      onPressed: () {
                        // TODO: mark the notification as read
                      },
                      icon: Icon(
                        Icons.add_rounded,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              NotificationCardCustom(),
              NotificationCardCustom(),
              NotificationCardCustom(),
              NotificationCardCustom(),
              NotificationCardCustom(),
              NotificationCardCustom(),
              NotificationCardCustom(),
            ],
          ),
        ),
      ),
    );
  }
}
