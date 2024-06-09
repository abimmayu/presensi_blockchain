import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';

class CopyPrivateKeyScreen extends StatefulWidget {
  const CopyPrivateKeyScreen({super.key});

  @override
  State<CopyPrivateKeyScreen> createState() => _CopyPrivateKeyScreenState();
}

class _CopyPrivateKeyScreenState extends State<CopyPrivateKeyScreen> {
  String? privateKey;

  @override
  void initState() {
    getPrivateKey();
    super.initState();
  }

  getPrivateKey() async {
    final storePrivateKey =
        await SecureStorage().readData(key: AppConstant.privateKey);
    setState(() {
      privateKey = storePrivateKey.toString();
    });
  }

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
              height: 30.h,
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 10.h,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: mainColor,
                    width: 2.w,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  privateKey.toString(),
                  style: normalText,
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            MainButton(
              width: 300.w,
              onTap: () {
                Clipboard.setData(
                  ClipboardData(
                    text: privateKey.toString(),
                  ),
                );
              },
              text: "Copy Private Key",
            )
          ],
        ),
      ),
    );
  }
}
