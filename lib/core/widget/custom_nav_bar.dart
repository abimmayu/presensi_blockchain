import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';

class CustomNavBar extends StatefulWidget {
  CustomNavBar({
    super.key,
    required this.currentIndex,
  });

  int currentIndex;

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  void onTapNav(int index) {
    switch (index) {
      case 0:
        context.pushNamed(AppRoute.dashboardScreen.name);
        break;
      case 1:
        context.pushNamed(AppRoute.presentScreen.name);
        break;
      case 2:
        context.pushNamed(AppRoute.userSettingScreen.name);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: onTapNav,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: mainColor,
            ),
            label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.file_present_outlined,
            color: mainColor,
          ),
          label: "Present",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
            color: mainColor,
          ),
          label: "User Settings",
        ),
      ],
    );
  }
}
