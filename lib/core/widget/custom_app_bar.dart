import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:presensi_blockchain/core/constant.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.leadingColor = blackColor,
    this.elevation = 2,
    this.color = whiteColor,
    this.leadingOnPressed,
    this.actionsIcon,
    this.actionsOnPressed,
    this.textColor = blackColor,
  });

  final String title;
  final Color leadingColor;
  final Function()? leadingOnPressed;
  final Function()? actionsOnPressed;
  final Widget? actionsIcon;
  final double elevation;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      elevation: elevation,
      title: Text(
        title,
        style: bigTextSemibold.copyWith(
          color: textColor,
        ),
      ),
      backgroundColor: color,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: leadingColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        actionsIcon != null
            ? IconButton(
                onPressed: actionsOnPressed,
                icon: actionsIcon!,
                color: blackColor,
              )
            : Container(),
      ],
    );
  }
}
