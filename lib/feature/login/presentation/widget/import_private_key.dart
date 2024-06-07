import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:svg_flutter/svg.dart';

class ImportPrivateKeyWidget extends StatelessWidget {
  const ImportPrivateKeyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(30),
      ),
      child: Column(
        children: [
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
                          hintText: "Input Private Key",
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
            height: 50.h,
          ),
          MainButton(
            text: "Submit",
            onTap: () {},
          )
        ],
      ),
    );
  }
}
