import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/core/widget/pin_modal.dart';
import 'package:svg_flutter/svg.dart';

class PrivateKeyScreen extends StatefulWidget {
  const PrivateKeyScreen({super.key});

  @override
  State<PrivateKeyScreen> createState() => _PrivateKeyScreenState();
}

class _PrivateKeyScreenState extends State<PrivateKeyScreen> {
  String? password;

  getPassword() async {
    final passwordStorage = await SecureStorage().readData(
      key: AppConstant.password,
    );
    setState(() {
      password = passwordStorage.toString();
    });
  }

  @override
  void initState() {
    getPassword();
    super.initState();
  }

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
                modalSeePrivateKey(
                  context,
                  password.toString(),
                );
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

  modalSeePrivateKey(BuildContext context, String password) async {
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
          function: () {
            if (controller.text == password) {
              context.pop();
              context.pushNamed(
                AppRoute.copyPrivateKeyScreen.name,
              );
            } else if (controller.text != password) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("The password is wrong!"),
                ),
              );
            }
          },
        );
      },
    );
  }
}
