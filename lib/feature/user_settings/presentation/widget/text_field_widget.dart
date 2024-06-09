import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    super.key,
    required this.title,
    required this.hintText,
    this.obsecure = false,
    required this.controller,
  });

  final String title;
  final String hintText;
  final bool obsecure;
  final TextEditingController controller;

  @override
  State<TextFieldWidget> createState() => _TextFielWidgetState();
}

class _TextFielWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenUtil().setHeight(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: normalText.copyWith(
              color: blackColor,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(
              top: ScreenUtil().setHeight(10),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(30),
              vertical: ScreenUtil().setHeight(10),
            ),
            child: TextField(
              obscureText: widget.obsecure,
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
