import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:svg_flutter/svg_flutter.dart';

class HomePresentedScreen extends StatelessWidget {
  const HomePresentedScreen({super.key});

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
          Container(
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
                              width: ScreenUtil().setWidth(160),
                              child: Text(
                                "Abim Mayu Indra Ardiansyah",
                                style: normalText,
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
                              width: ScreenUtil().setWidth(160),
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
                              width: ScreenUtil().setWidth(160),
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
          ),
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
                "16:00 WIB",
                style: normalText,
              ),
            ],
          ),
          SizedBox(
            height: ScreenUtil().setHeight(50),
          ),
          //Disini munculin Maps
          Container(
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
          ),
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
              onTap: () {},
              text: 'Submit',
            ),
          )
        ],
      ),
    );
  }
}
