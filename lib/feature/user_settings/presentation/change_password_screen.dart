import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Change Password",
          elevation: 0,
          color: mainColor,
          textColor: whiteColor,
          leadingColor: whiteColor,
        ),
      ),
      backgroundColor: mainColor,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Old password:",
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
                    child: const TextField(
                      decoration: InputDecoration(
                          hintText: "Type your old password here!"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New password:",
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
                    child: const TextField(
                      decoration: InputDecoration(
                          hintText: "Type your new password here!"),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ScreenUtil().setHeight(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirm the new password:",
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
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: "Re-type your new password here!",
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            MainButton(
              onTap: () {},
              text: "Submit",
              color: whiteColor,
              textColor: mainColor,
            )
          ],
        ),
      ),
    );
  }
}
