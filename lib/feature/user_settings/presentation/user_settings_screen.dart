import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/routing/router.dart';
import 'package:presensi_blockchain/core/widget/custom_nav_bar.dart';

class UserSettingsScreen extends StatelessWidget {
  UserSettingsScreen({super.key});

  final List icon = [
    Icons.person,
    Icons.account_balance_wallet,
    Icons.key,
    Icons.logout,
  ];
  final List title = [
    "Profile Settings",
    "Import Wallet",
    "Change Password",
    "Logout",
  ];

  @override
  Widget build(BuildContext context) {
    List action = [
      () {
        context.pushNamed(
          AppRoute.profileSettingScreen.name,
        );
      },
      () {
        context.pushNamed(
          AppRoute.importWalletScreen.name,
        );
      },
      () {
        context.pushNamed(
          AppRoute.changePasswordScreen.name,
        );
      },
      () {},
    ];
    return Scaffold(
      bottomNavigationBar: const CustomNavBar(
        currentIndex: 2,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: ScreenUtil().setHeight(350),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: greyColor,
                        offset: Offset(0, 4),
                        spreadRadius: 4,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  width: MediaQuery.sizeOf(context).width,
                  height: ScreenUtil().setHeight(300),
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://d1bpj0tv6vfxyp.cloudfront.net/alasan-orang-yang-sibuk-kerja-harus-olahraga-ringan-teratur-halodoc.png',
                              ),
                              fit: BoxFit.cover,
                              scale: 1,
                            ),
                            borderRadius: BorderRadius.circular(150),
                            border: Border.all(
                              color: whiteColor,
                              width: ScreenUtil().setWidth(5),
                            ),
                          ),
                          height: ScreenUtil().setHeight(150),
                          width: ScreenUtil().setHeight(150),
                        ),
                        Positioned(
                          right: ScreenUtil().setWidth(10),
                          bottom: 0,
                          child: Container(
                            width: ScreenUtil().setHeight(35),
                            height: ScreenUtil().setHeight(35),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.photo_camera,
                              color: blackColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: ScreenUtil().setWidth(45),
                  child: Container(
                    padding: EdgeInsets.all(
                      ScreenUtil().setHeight(10),
                    ),
                    height: ScreenUtil().setHeight(100),
                    width: ScreenUtil().setWidth(300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: mainColor,
                      boxShadow: const [
                        BoxShadow(
                          color: greyColor,
                          spreadRadius: 4,
                          offset: Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                      border: Border.all(
                        color: whiteColor,
                        width: ScreenUtil().setWidth(2),
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: ScreenUtil().setHeight(40),
                          child: Text(
                            "Abim Mayu Indra Ardiansyah",
                            style: normalText.copyWith(color: whiteColor),
                          ),
                        ),
                        Text(
                          "198503302003121002",
                          style: tinyText.copyWith(color: whiteColor),
                        ),
                        Text(
                          "Staff Ahli Lab Komputer",
                          style: tinyText.copyWith(color: whiteColor),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(30),
          ),
          Row(
            children: [
              SizedBox(
                width: ScreenUtil().setWidth(50),
              ),
              Text(
                "App Settings",
                style: normalText.copyWith(
                  color: greyColor,
                ),
              ),
            ],
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: icon.length,
            itemBuilder: (context, value) {
              return ListTile(
                leading: Icon(
                  icon[value],
                  color: mainColor,
                  size: ScreenUtil().setHeight(30),
                ),
                title: Text(
                  title[value],
                  style: normalText,
                ),
                trailing: const Icon(
                  Icons.arrow_right_sharp,
                ),
                onTap: action[value],
              );
            },
          ),
        ],
      ),
    );
  }
}
