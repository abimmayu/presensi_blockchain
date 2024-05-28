import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    this.height,
    this.width,
    this.text,
    this.textColor,
    this.color,
    required this.onTap,
  });

  final int? height;
  final num? width;
  final String? text;
  final Color? color;
  final Color? textColor;
  final Function() onTap;

  @override
  Widget build(context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color ?? mainColor,
        ),
        height: height != null
            ? ScreenUtil().setHeight(height!)
            : ScreenUtil().setHeight(60),
        width: width != null
            ? ScreenUtil().setWidth(width!)
            : ScreenUtil().setHeight(270),
        child: Center(
          child: Text(
            text != null ? text! : '',
            style: regularText.copyWith(
              color: textColor ?? whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}
