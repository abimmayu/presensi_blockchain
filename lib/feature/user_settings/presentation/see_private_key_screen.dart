import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:svg_flutter/svg.dart';

class PrivateKeyScreen extends StatelessWidget {
  const PrivateKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: "Private Key"),
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              child: SvgPicture.asset(
                "assets/images/On Press Button.svg",
              ),
              onLongPress: () {
                log(
                  "this is see private key",
                );
                modalSeePrivateKey(context);
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(300),
              child: Text(
                "Press and Hold the button to show your private key",
                style: normalText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  modalSeePrivateKey(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(30),
          ),
          // height: MediaQuery.sizeOf(context).width / 2,
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: ScreenUtil().setWidth(200),
                  height: ScreenUtil().setHeight(10),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: greyColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              SizedBox(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: ScreenUtil().setWidth(9),
                        ),
                        SvgPicture.asset(
                          'assets/images/Password logo.svg',
                          height: ScreenUtil().setHeight(30),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(12),
                        ),
                        SizedBox(
                          width: ScreenUtil().setWidth(250),
                          child: const TextField(
                            obscureText: true,
                            decoration: InputDecoration.collapsed(
                              hintText: "Type your password",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: blackColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(50),
              ),
              MainButton(
                text: "Submit",
                onTap: () {
                  context.pushNamed(
                    AppRoute.copyPrivateKeyScreen.name,
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
