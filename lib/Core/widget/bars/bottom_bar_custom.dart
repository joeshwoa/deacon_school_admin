import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class BottomBarCustom extends StatefulWidget {
  final Function(int) onChangePage;
  final Color barBackgroundColor;
  final Color itemBorderTopColorOn;
  final Color itemBorderTopColorOff;
  final Color? itemShadowTopGradientColor;
  final Curve curveOn;
  final Curve curveOff;
  final BorderRadiusGeometry? barBorderRadius;
  final BorderRadiusGeometry? itemBorderRadius;
  final Duration durationAnimation;
  final List<NavigationBarItemCustom> items;
  final int startIndex;
  const BottomBarCustom({super.key, required this.onChangePage, required this.items, this.barBackgroundColor = Colors.black, this.barBorderRadius, this.itemBorderRadius, this.curveOn = Curves.bounceIn, this.curveOff = Curves.easeOut, this.durationAnimation = const Duration(milliseconds: 600), this.itemBorderTopColorOn = Colors.green, this.itemBorderTopColorOff = Colors.grey, this.startIndex = 0, this.itemShadowTopGradientColor});

  @override
  State<BottomBarCustom> createState() => _BottomBarCustomState();
}

class _BottomBarCustomState extends State<BottomBarCustom> {

  int itemIndex = 0;

  @override
  void initState() {
    itemIndex = widget.startIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: widget.barBackgroundColor,
          borderRadius: widget.barBorderRadius??BorderRadius.only(topRight: Radius.circular(25), topLeft: Radius.circular(25))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(widget.items.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  itemIndex = index;
                  widget.onChangePage(index);
                });
              },
              child: ClipRRect(
                borderRadius: widget.itemBorderRadius??BorderRadius.circular(6),
                child: AnimatedContainer(
                  curve: index == itemIndex ? widget.curveOn : widget.curveOff,
                  duration: widget.durationAnimation,
                  width: 60,
                  height: 60,
                  child: index == itemIndex ? widget.items[index].selectedChild : widget.items[index].unselectedChild,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: index == itemIndex ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          widget.itemShadowTopGradientColor ?? Colors.green.shade700.withOpacity(0.5),
                          widget.barBackgroundColor,
                          widget.barBackgroundColor
                        ]
                    ) : null,
                    border: Border(
                        top: BorderSide(
                            color: index == itemIndex ? widget.itemBorderTopColorOn : widget.itemBorderTopColorOff,
                            width: index == itemIndex ? 5 : 3
                        ),
                    ),
                  ),
                ),
              ),
            );
          },),
        ],
      ),
    );
  }
}

class NavigationBarItemCustom {
  final Widget unselectedChild;
  final Widget selectedChild;

  NavigationBarItemCustom({
    required this.selectedChild,
    required this.unselectedChild,
  });
}
