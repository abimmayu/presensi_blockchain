import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/service/blockchain_service.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/feature/present/domain/usecase/check_location_usecase.dart';

class PresentedScreenParam {
  Position position;

  PresentedScreenParam(this.position);
}

class PresentedScreen extends StatefulWidget {
  const PresentedScreen({super.key, required this.param});

  final PresentedScreenParam param;

  @override
  State<PresentedScreen> createState() => _PresentedScreenState();
}

class _PresentedScreenState extends State<PresentedScreen> {
  final BlockchainService service = BlockchainService();

  final userId = FirebaseAuth.instance.currentUser!.uid;

  final String privateKey =
      "12413019a6025e5238f2b06222cc1228ba39da398af30273282670f2435a8bfc";

  bool locationStatus = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Presensi",
          color: mainColor,
          elevation: 0,
        ),
      ),
      body: ListView(
        children: [
          header(),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          Column(
            children: [
              Text(
                "Senin, 1 Januari 2023",
                style: normalText,
              ),
              Text(
                "8:00 WIB",
                style: normalText,
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          //Disini munculin Maps
          maps(),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          Center(
            child: Text(
              "Anda berada di lokasi kerja.",
              style: normalText,
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: ScreenUtil().setWidth(20),
            ),
            child: MainButton(
              onTap: () {
                service.postFunction(
                  functionName: AppConstant.inputPresent,
                  privateKey: privateKey,
                  param: [
                    BigInt.from(1),
                    BigInt.from(2),
                  ],
                ).then(
                  (value) => context.pushNamed(
                    AppRoute.presentSuccessScreen.name,
                  ),
                );
                // CheckCorrectLocationUsecase()
                //     .checkLocationStatus(
                //       LatLng(
                //         widget.param.position.latitude,
                //         widget.param.position.longitude,
                //       ),
                //     )
                //     .then(
                //       (value) => setState(() {
                //         locationStatus = value;
                //         log("location status: $locationStatus");
                //       }),
                //     );
              },
              text: 'Submit',
            ),
          )
        ],
      ),
    );
  }

  Widget header() {
    return Container(
      decoration: BoxDecoration(
        color: mainColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 0.4,
            color: blackColor.withOpacity(0.25),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: whiteColor,
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://d1bpj0tv6vfxyp.cloudfront.net/alasan-orang-yang-sibuk-kerja-harus-olahraga-ringan-teratur-halodoc.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              height: ScreenUtil().setHeight(100),
              width: ScreenUtil().setHeight(100),
            ),
            SizedBox(
              width: ScreenUtil().setWidth(10),
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ScreenUtil().setWidth(80),
                        child: Text(
                          "Nama",
                          style: normalText,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                        child: Text(
                          ":",
                          style: normalText,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(150),
                        child: Text(
                          "Abim Mayu Indra Ardiansyah",
                          style: normalText,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(10),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ScreenUtil().setWidth(80),
                        child: Text(
                          "NIP",
                          style: tinyText,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                        child: Text(
                          ":",
                          style: tinyText,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(150),
                        child: Text(
                          "198503302003121002",
                          style: tinyText,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: ScreenUtil().setWidth(80),
                        child: Text(
                          "Jabatan",
                          style: tinyText,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(10),
                        child: Text(
                          ":",
                          style: tinyText,
                        ),
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(150),
                        child: Text(
                          "Staff IT TIK FMIPA",
                          style: tinyText,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget maps() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
      ),
      height: ScreenUtil().setHeight(222),
      width: ScreenUtil().setWidth(200),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://statik.tempo.co/data/2019/01/23/id_813830/813830_720.jpg',
          ),
          fit: BoxFit.cover,
        ),
        color: mainColor,
      ),
    );
  }
}
