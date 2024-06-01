import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:svg_flutter/svg_flutter.dart';

class PinInputModal extends StatelessWidget {
  const PinInputModal({
    super.key,
    required this.controller,
    required this.function,
  });

  final TextEditingController controller;
  final Function() function;

  @override
  Widget build(BuildContext context) {
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
  }
}
