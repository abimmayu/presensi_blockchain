import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/widget/button.dart';

class ImportRecoveryPhraseWidget extends StatefulWidget {
  const ImportRecoveryPhraseWidget({super.key});

  @override
  State<ImportRecoveryPhraseWidget> createState() =>
      _ImportRecoveryPhraseWidgetState();
}

class _ImportRecoveryPhraseWidgetState
    extends State<ImportRecoveryPhraseWidget> {
  final int phraseLength = 12;

  late List<TextEditingController> controllers;

  @override
  void initState() {
    controllers = List.generate(
      phraseLength,
      (index) => TextEditingController(),
    );
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      child: Column(
        children: [
          Container(
            height: 250.h,
            padding: EdgeInsets.only(bottom: 10.h),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 20.h,
                mainAxisExtent: 40.h,
              ),
              itemCount: phraseLength,
              itemBuilder: (context, index) {
                return TextField(
                  controller: controllers[index],
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    labelText: 'Word ${index + 1}',
                    border: const OutlineInputBorder(),
                  ),
                );
              },
            ),
          ),
          MainButton(
            onTap: () {},
            text: "Submit",
          ),
        ],
      ),
    );
  }
}
