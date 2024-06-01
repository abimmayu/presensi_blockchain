import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';

class ListUserSettingsWidget extends StatelessWidget {
  const ListUserSettingsWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.action,
  });

  final IconData icon;
  final String title;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: mainColor,
        size: 30.h,
      ),
      title: Text(
        title,
        style: normalText,
      ),
      trailing: const Icon(
        Icons.arrow_right_sharp,
      ),
      onTap: action,
    );
  }
}
