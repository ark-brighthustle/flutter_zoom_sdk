import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/bottom_navbar.dart';
import 'package:flutter_zoom_sdk_example/page/classroom/classroom_page.dart';
import 'package:flutter_zoom_sdk_example/theme/material_colors.dart';
import 'package:flutter_zoom_sdk_example/utils/constant.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'helpers/helpers.dart';
import 'page/login_page.dart';
import 'theme/colors.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

String? token;

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  token = await Helpers().getToken();
  await initializeDateFormatting('id_ID', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: titleApp,
      theme: ThemeData(
        primarySwatch: colorCelticBlue, fontFamily: 'Montserrat'
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreens(),
    );
  }
}

class SplashScreens extends StatelessWidget {
  const SplashScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
        backgroundColor: kWhite,
        imageSrc: 'assets/logo_app.png',
        imageSize: 320,
        duration: 3000,
        navigateRoute: token == null ? const LoginPage() : const BottomNavbar());
  }
}

