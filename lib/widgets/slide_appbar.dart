import 'package:flutter/material.dart';


//动画
class SlideAppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const SlideAppbarWidget({
    Key? key,
    required this.child,
    required this.controller,
    required this.visible,
  }) : super(key: key);

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward(); //动画设置
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, -1),
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.fastOutSlowIn,  //动画速度匀变慢
        ),
      ),
      child: child,
    );
  }
}
