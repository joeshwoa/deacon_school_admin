import 'package:deacon_school_admin/Core/cubit/layout_cubit.dart';
import 'package:deacon_school_admin/Core/helper/cache_image.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/unit/style_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AppBarCustom extends StatelessWidget {
  AppBarCustom({super.key, });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorData.whiteColor,
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: SizedBox(height: 50,)),
          if(context.read<LayoutCubit>().selectedPageIndex == 0)GestureDetector(
            onTap: () {

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
                Icons.add_rounded,
                size: 22,
              ),
            ),
          ),
          const Gap(8),
          GestureDetector(
            onTap: () {
              context.read<LayoutCubit>().toggleNotificationsBox();
            },
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                  color:  ColorData.secondaryBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: ColorData.primaryBorderColor,
                      width: 1
                  )
              ),
              clipBehavior: Clip.antiAlias,
              child: Icon(
                Icons.notifications_rounded,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
