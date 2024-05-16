import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/routing/router.dart';

void main() {
  const contractUrl =
      "https://sepolia.infura.io/v3/a555c4f5ab0a4baf89bcc0e4963c0b3c";

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
