import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color
const Color mainColor = Color(0xFFff9912);
const Color whiteColor = Color(0xFFFFFFFF);
const Color blackColor = Color(0xFF000000);
const Color greyColor = Color(0xFFBAB7B7);

// Text Style
final TextStyle headingBold = GoogleFonts.montserrat(
  fontSize: 36,
  fontWeight: FontWeight.bold,
);
final TextStyle headingNormal = GoogleFonts.montserrat(
  fontSize: 36,
  fontWeight: FontWeight.w600,
);
final TextStyle bigTextRegular = GoogleFonts.montserrat(
  fontSize: 24,
  fontWeight: FontWeight.normal,
);
final TextStyle bigTextSemibold = GoogleFonts.montserrat(
  fontSize: 24,
  fontWeight: FontWeight.w600,
);
final TextStyle regularText = GoogleFonts.montserrat(
  fontSize: 20,
  fontWeight: FontWeight.w600,
);
final TextStyle normalText = GoogleFonts.montserrat(
  fontSize: 16,
  fontWeight: FontWeight.w500,
);
final TextStyle tinyText = GoogleFonts.montserrat(
  fontSize: 12,
  fontWeight: FontWeight.w500,
);

//Variable
class AppConstant {
  //User Credential
  static const String userEmail = "user_email";
  static const String userPassword = "user_password";

  //Contract Detail
  static const String contractAddress =
      "0xf9DB75dc762cD1e60ac3862dd7be757BD52fbe9a";
  static const String contractName = "Presence";

  //Name of Contract Function
  static const String addPresent = "addPresent";
  static const String getPresent = "getPresent";
  static const String getAllPresents = "getAllPresents";
  static const String getLastPresentId = "getLastPresentId";
  static const String addEmployee = "addEmployee";
  static const String inputPresent = "inputPresent";
  static const String getEmployeePresentInMonth = "getEmployeePresentInMonth";
  static const String getEmployeePresentOutMonth = "getEmployeePresentOutMonth";
  static const String getEmployeePresentInYear = "getEmployeePresentInYear";
  static const String getEmployeePresentOutYear = "getEmployeePresentOutYear";

  //Storage key
  static const String password = "password";
  static const String address = "address";
  static const String publicKey = "publicKey";
  static const String privateKey = "privateKey";
  static const String recoveryPhrase = "recoveryPhrase";
  static const String refreshToken = "refreshToken";
}
