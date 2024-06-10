import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/core/widget/pin_modal.dart';
import 'package:svg_flutter/svg_flutter.dart';

class RecoveryPhraseScreen extends StatefulWidget {
  const RecoveryPhraseScreen({super.key});

  @override
  State<RecoveryPhraseScreen> createState() => _RecoveryPhraseScreenState();
}

class _RecoveryPhraseScreenState extends State<RecoveryPhraseScreen> {
  String? password;

  @override
  void initState() {
    getPassword();
    super.initState();
  }

  getPassword() async {
    final passwordStorage = await SecureStorage().readData(
      key: AppConstant.password,
    );
    setState(() {
      password = passwordStorage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: "Recovery Phrase"),
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
                  "this is see recovery phrase",
                );
                modalSeePrivateKey(context, password);
              },
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(300),
              child: Text(
                "Press and Hold the button to show your recovery phrase",
                style: normalText,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  modalSeePrivateKey(
    BuildContext context,
    String? password,
  ) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return PinInputModal(
            controller: controller,
            onChanged: (value) {
              setState(() {
                controller.text = value;
              });
            },
            onSubmitted: (value) {
              if (value == password) {
                context.pop();
                context.pushNamed(
                  AppRoute.copyRecoveryPhraseScreen.name,
                );
              } else if (value != password) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("The password is wrong!"),
                  ),
                );
              }
            },
            function: () {
              if (controller.text == password) {
                context.pop();
                context.pushNamed(
                  AppRoute.copyRecoveryPhraseScreen.name,
                );
              } else if (controller.text != password) {
                context.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("The password is wrong!"),
                  ),
                );
              }
            });
      },
    );
  }
}
