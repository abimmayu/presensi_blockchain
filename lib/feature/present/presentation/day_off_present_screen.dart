import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';

class DayOffScreen extends StatelessWidget {
  const DayOffScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Izin",
          textColor: whiteColor,
          color: mainColor,
          leadingColor: whiteColor,
          elevation: 0,
        ),
      ),
      backgroundColor: mainColor,
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(20),
        ),
        children: [
          Text(
            "Input your reason here:",
            style: normalText.copyWith(
              color: whiteColor,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          Container(
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(15),
              vertical: ScreenUtil().setWidth(15),
            ),
            height: ScreenUtil().setHeight(237),
            child: const TextField(
              maxLines: 10,
              maxLength: 368,
              decoration: InputDecoration.collapsed(
                hintText: "",
              ),
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          Text(
            "Input the documentation (optional):",
            style: normalText.copyWith(
              color: whiteColor,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: ScreenUtil().setHeight(100),
                width: ScreenUtil().setWidth(100),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.add_a_photo,
                  color: mainColor,
                  size: ScreenUtil().setHeight(50),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(100),
                width: ScreenUtil().setWidth(100),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.add_a_photo,
                  color: mainColor,
                  size: ScreenUtil().setHeight(50),
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(100),
                width: ScreenUtil().setWidth(100),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.add_a_photo,
                  color: mainColor,
                  size: ScreenUtil().setHeight(50),
                ),
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(100),
          ),
          MainButton(
            onTap: () {},
            text: "Submit",
            textColor: mainColor,
            color: whiteColor,
          )
        ],
      ),
    );
  }
}
