import 'package:flutter/material.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';

class DropdownDateWidget extends StatelessWidget {
  const DropdownDateWidget({
    super.key,
    required this.value,
    required this.dateOption,
    required this.dateTitle,
    required this.onSelected,
  });

  final int value;
  final List dateOption;
  final List dateTitle;
  final Function(dynamic) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: blackColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<int>(
        value: value,
        items: dateOption.map(
          (e) {
            return DropdownMenuItem<int>(
              value: e,
              child: Text(
                "${dateTitle[e]}",
              ),
            );
          },
        ).toList(),
        onChanged: onSelected,
      ),
    );
  }
}
