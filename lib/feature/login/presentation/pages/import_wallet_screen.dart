import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/feature/login/presentation/widget/import_recovery_phrase.dart';

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({super.key});

  @override
  State<ImportWalletScreen> createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  final TextEditingController controller = TextEditingController();

  int index = 0;

  final List<Widget> widgets = [
    const ImportRecoveryPhraseWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150.h,
            ),
            Text(
              "Your account have a wallet.",
              style: bigTextSemibold,
            ),
            Text(
              "Please import your wallet!",
              style: normalText,
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: widgets[index],
            ),
          ],
        ),
      ),
    );
  }
}
