import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/core/widget/button.dart';

class DoneCreateWalletScreen extends StatefulWidget {
  const DoneCreateWalletScreen({super.key});

  @override
  State<DoneCreateWalletScreen> createState() => _DoneCreateWalletScreenState();
}

class _DoneCreateWalletScreenState extends State<DoneCreateWalletScreen> {
  String? mnemonicPhrase;

  @override
  void initState() {
    getMnemonicPhrase();
    super.initState();
  }

  getMnemonicPhrase() async {
    final mnemonic = await SecureStorage().readData(
      key: AppConstant.recoveryPhrase,
    );

    setState(
      () {
        mnemonicPhrase = mnemonic.toString();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 50.h),
            child: Column(
              children: [
                Text(
                  "Please copy your recovery phrase on another place.",
                  style: bigTextSemibold,
                ),
                Text(
                  "You can save it on your own note, paper, etc. This recovery phrase will be used while you want to import your present's wallet.",
                  style: normalText,
                ),
              ],
            ),
          ),
          Center(
            child: Container(
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
              child: Column(
                children: [
                  Text(
                    "$mnemonicPhrase",
                    style: normalText,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(20),
                  ),
                  MainButton(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: "$mnemonicPhrase",
                        ),
                      );
                    },
                    text: "Copy Recovery Phrase",
                    width: 300,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          MainButton(
            onTap: () {
              context.pushReplacementNamed(AppRoute.presentScreen.name);
            },
            text: "Next to Present Screen",
            width: 300.w,
          ),
        ],
      ),
    );
  }
}
