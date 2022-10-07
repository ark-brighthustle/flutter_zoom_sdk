import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/bottom_navbar.dart';
import 'package:flutter_zoom_sdk_example/theme/material_colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'helpers/helpers.dart';
import 'login.dart';
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
  await initializeDateFormatting('id_ID', null).then((_) => runApp(ExampleApp()));
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart School',
      theme: ThemeData(
        primarySwatch: colorCelticBlue, fontFamily: 'Montserrat'
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreens(),
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
        navigateRoute: token == null ? const Login() : const BottomNavbar());
  }
}

