import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:svg_flutter/svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          height: ScreenUtil().setHeight(456),
          width: ScreenUtil().setWidth(332),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 3,
                offset: const Offset(0, 4),
                color: blackColor.withOpacity(0.3),
              )
            ],
            color: whiteColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: headingBold,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(70),
                ),
                SizedBox(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: ScreenUtil().setWidth(6),
                          ),
                          SvgPicture.asset(
                            'assets/images/ID Number logo.svg',
                            height: ScreenUtil().setHeight(20),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(15),
                          ),
                          Text(
                            'Type your ID Number',
                            style: normalText.copyWith(
                              color: greyColor,
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
                  height: ScreenUtil().setHeight(35),
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
                          Text(
                            'Type your password',
                            style: normalText.copyWith(
                              color: greyColor,
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
                  onTap: () {
                    context.goNamed(AppRoute.dashboardScreen.name);
                  },
                  text: 'Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
