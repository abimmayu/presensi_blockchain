import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';

class ImportWalletScreen extends StatelessWidget {
  const ImportWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: "Import Wallet"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(20),
          vertical: ScreenUtil().setHeight(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(50),
                ),
                Text(
                  "Input your private key",
                  style: normalText,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(10),
                    horizontal: ScreenUtil().setWidth(10),
                  ),
                  margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(10),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: mainColor,
                      width: ScreenUtil().setWidth(2),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const TextField(
                    decoration: InputDecoration.collapsed(hintText: ""),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            MainButton(
              onTap: () {},
              text: "Import",
            ),
          ],
        ),
      ),
    );
  }
}
