import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationCardCustom extends StatelessWidget {
  const NotificationCardCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  'النهاردة مفيش حصة الحان',
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
              Icons.delete_rounded,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
