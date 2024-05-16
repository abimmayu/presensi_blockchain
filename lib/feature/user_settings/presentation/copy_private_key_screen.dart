import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';

class CopyPrivateKeyScreen extends StatelessWidget {
  const CopyPrivateKeyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: "Private Key"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Container(
              height: ScreenUtil().setHeight(100),
              padding: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(10),
                vertical: ScreenUtil().setHeight(10),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: ScreenUtil().setWidth(10),
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: mainColor,
                    width: ScreenUtil().setWidth(2),
                  ),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "e4670281e80550a2a5dd5b68e93aaf66032b0d5be024b661b02731905ae0c516",
                style: normalText,
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            MainButton(
              width: ScreenUtil().setWidth(250),
              onTap: () {},
              text: "Copy Private Key",
            )
          ],
        ),
      ),
    );
  }
}
