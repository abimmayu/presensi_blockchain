import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:presensi_blockchain/core/utils/constant.dart';
import 'package:presensi_blockchain/core/service/blockchain_service.dart';
import 'package:presensi_blockchain/core/utils/secure_storage.dart';
import 'package:presensi_blockchain/core/widget/button.dart';
import 'package:presensi_blockchain/core/widget/custom_app_bar.dart';
import 'package:presensi_blockchain/core/widget/pin_modal.dart';
import 'package:presensi_blockchain/feature/present/presentation/bloc/present_bloc.dart';
import 'package:presensi_blockchain/feature/user_settings/presentation/bloc/user_bloc.dart';

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

  // final String privateKey =
  //     "12413019a6025e5238f2b06222cc1228ba39da398af30273282670f2435a8bfc";
  String privateKey = "";

  bool locationStatus = false;
  final now = DateTime.now();
  final dateFormat = DateFormat('EEEE, d MMMM yyyy');
  final hourFormat = DateFormat('jm');

  String? password;

  getPassword() async {
    final passwordStorage = await SecureStorage().readData(
      key: AppConstant.password,
    );
    setState(() {
      password = passwordStorage;
    });
  }

  Future<void> checkLocation() {
    return Future(
      () => context.read<PresentBloc>().add(
            CheckLocation(
              LatLng(
                widget.param.position.latitude,
                widget.param.position.longitude,
              ),
            ),
          ),
    );
  }

  void getPrivateKey() async {
    final privateKeyStorage = await SecureStorage().readData(
      key: AppConstant.privateKey,
    );
    setState(() {
      privateKey = privateKeyStorage.toString();
    });
  }

  @override
  void initState() {
    checkLocation();
    getPrivateKey();
    getPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = dateFormat.format(now);
    final hour = hourFormat.format(now);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: "Presensi",
          color: mainColor,
          elevation: 0,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => checkLocation(),
        child: ListView(
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoaded) {
                  return header(state.user);
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                );
              },
            ),
            body(date, hour),
          ],
        ),
      ),
    );
  }

  Widget body(
    String date,
    String hour,
  ) {
    return Column(
      children: [
        SizedBox(
          height: ScreenUtil().setHeight(50),
        ),
        Column(
          children: [
            Text(
              date,
              style: normalText,
            ),
            Text(
              "$hour WIB",
              style: normalText,
            ),
          ],
        ),
        SizedBox(
          height: ScreenUtil().setHeight(50),
        ),
        BlocBuilder<PresentBloc, PresentState>(
          builder: (context, state) {
            if (state is LocationMatch) {
            } else if (state is LocationNotMatch) {
              return Center(
                child: Text(
                  "Anda tidak berada di lokasi kerja.",
                  style: normalText,
                ),
              );
            } else if (state is PresentLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              );
            }
            return Center(
              child: Text(
                "Anda berada di lokasi kerja.",
                style: normalText,
              ),
            );
          },
        ),
        SizedBox(
          height: ScreenUtil().setHeight(75),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: ScreenUtil().setWidth(100),
          ),
          child: BlocConsumer<PresentBloc, PresentState>(
            listener: (context, state) {
              log(state.toString());
              if (state is PresentFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is StartPresent) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                );
              } else if (state is LocationMatch) {
                return MainButton(
                  onTap: () {
                    final hourPresentStart = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      8,
                      0,
                    ).millisecondsSinceEpoch;
                    final hourPresentEnd = DateTime(
                      now.year,
                      now.month,
                      now.day,
                      8,
                      30,
                      0,
                    ).millisecondsSinceEpoch;
                    if (now.millisecondsSinceEpoch >= hourPresentStart &&
                        now.millisecondsSinceEpoch <= hourPresentEnd) {
                      modalSeePrivateKey(
                        context,
                        password.toString(),
                      );
                    } else if (now.millisecondsSinceEpoch < hourPresentStart) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return dialogPresent(
                            "The present it isn't started yet!",
                          );
                        },
                      );
                    } else if (now.millisecondsSinceEpoch > hourPresentEnd) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return dialogPresent(
                            "You're late to do your present",
                          );
                        },
                      );
                    }
                  },
                  text: 'Submit',
                );
              }
              return MainButton(
                onTap: () {},
                text: "Submit",
                color: greyColor,
                textColor: whiteColor,
              );
            },
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }

  dialogPresent(String content) {
    return AlertDialog(
      title: Text(
        "It's not the Present's Time!",
        style: bigTextSemibold,
      ),
      content: Text(
        content,
        style: normalText,
      ),
      actions: [
        InkWell(
          onTap: () {
            context.pop();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.2, vertical: 5.h),
            decoration: BoxDecoration(
              color: mainColor,
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: const Text("Ok"),
          ),
        )
      ],
    );
  }

  modalSeePrivateKey(BuildContext context, String password) {
    final now = DateTime.now();
    final idPresentNow =
        DateTime(now.year, now.month, now.day, 7, 0).millisecondsSinceEpoch;
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
          onChanged: (value) {
            setState(() {
              controller.text = value;
            });
          },
          onSubmitted: (value) {
            if (value == password) {
              context.pop();
              context.read<PresentBloc>().add(
                    InputPresent(
                      BigInt.from(idPresentNow),
                      BigInt.from(6),
                    ),
                  );
            } else if (value != password) {
              context.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("The password is wrong!"),
                ),
              );
            }
          },
          function: () {
            if (controller.text == password) {
              context.pop();
              context.read<PresentBloc>().add(
                    InputPresent(
                      BigInt.from(1),
                      BigInt.from(3),
                    ),
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

  Widget header(dynamic data) {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //     color: whiteColor,
            //     image: const DecorationImage(
            //       image: NetworkImage(
            //         'https://d1bpj0tv6vfxyp.cloudfront.net/alasan-orang-yang-sibuk-kerja-harus-olahraga-ringan-teratur-halodoc.png',
            //       ),
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            //   height: ScreenUtil().setHeight(100),
            //   width: ScreenUtil().setHeight(100),
            // ),
            // SizedBox(
            //   width: ScreenUtil().setWidth(10),
            // ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        width: ScreenUtil().setWidth(260),
                        child: Text(
                          data["name"],
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
                          data["nip"] is double
                              ? "${(data["nip"] as double).toInt()}"
                              : "${data["nip"]}",
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
                          data["occupation"],
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
