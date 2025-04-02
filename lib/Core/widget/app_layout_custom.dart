import 'package:deacon_school_admin/Core/cubit/layout_cubit.dart';
import 'package:deacon_school_admin/Core/unit/color_data.dart';
import 'package:deacon_school_admin/Core/widget/bars/app_bar_custom.dart';
import 'package:deacon_school_admin/Core/widget/bars/bottom_bar_custom.dart';
import 'package:deacon_school_admin/Core/widget/notifications_box_custom.dart';
import 'package:deacon_school_admin/Core/widget/search_box_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLayoutCustom extends StatelessWidget {
  const AppLayoutCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutCubit, LayoutState>(
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              Scaffold(
                backgroundColor: ColorData.whiteColor,
                appBar: PreferredSize(
                  child: AppBarCustom(),
                  preferredSize: Size.fromHeight(70),
                ),
                body: context.read<LayoutCubit>().pages[context.read<LayoutCubit>().selectedPageIndex],
                bottomNavigationBar: BottomBarCustom(
                  onChangePage: (c) {
                    context.read<LayoutCubit>().changePage(c);
                  },
                  barBorderRadius: BorderRadius.zero,
                  barBackgroundColor: ColorData.whiteColor,
                  itemBorderTopColorOn: ColorData.primaryColor,
                  itemShadowTopGradientColor: ColorData.primaryColor,
                  itemBorderTopColorOff: ColorData.whiteColor,
                  items: [
                    NavigationBarItemCustom(
                        selectedChild: Icon(
                          Icons.video_library_rounded,
                          color: ColorData.primaryColor,
                          size: 30,
                        ),
                        unselectedChild: Icon(
                          Icons.video_library_outlined,
                          color: ColorData.primaryLightColor,
                          size: 30,
                        )
                    ),
                    NavigationBarItemCustom(
                        selectedChild: Icon(
                          Icons.assessment_rounded,
                          color: ColorData.primaryColor,
                          size: 30,
                        ),
                        unselectedChild: Icon(
                          Icons.assessment_outlined,
                          color: ColorData.primaryLightColor,
                          size: 30,
                        )
                    ),
                    NavigationBarItemCustom(
                        selectedChild: Icon(
                          Icons.person_rounded,
                          color: ColorData.primaryColor,
                          size: 30,
                        ),
                        unselectedChild: Icon(
                          Icons.person_outlined,
                          color: ColorData.primaryLightColor,
                          size: 30,
                        )
                    ),
                  ],
                ),
              ),
              if(context.read<LayoutCubit>().showSearchBox) Positioned(
                left:MediaQuery.of(context).size.width*0.23,
                top: 50,
                child: SearchBoxCustom(),
              ),
              if(context.read<LayoutCubit>().showNotificationsBox) Positioned(
                left:MediaQuery.of(context).size.width*0.10,
                top: 50,
                child: NotificationsBoxCustom(),
              )
            ],
          ),
        );
      },
    );
  }
}
