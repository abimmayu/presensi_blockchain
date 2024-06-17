import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';

class CopyRecoveryPhraseScreen extends StatefulWidget {
  const CopyRecoveryPhraseScreen({super.key});

  @override
  State<CopyRecoveryPhraseScreen> createState() =>
      _CopyRecoveryPhraseScreenState();
}

class _CopyRecoveryPhraseScreenState extends State<CopyRecoveryPhraseScreen> {
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

    setState(() {
      mnemonicPhrase = mnemonic.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: "Recovery Phrase"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }
}
