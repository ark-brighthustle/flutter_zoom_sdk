import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'page/classroom/classroom_page.dart';
import 'page/delay_streaming/delay_streaming_page.dart';
import 'page/downloads/download_page.dart';
import 'page/home_page.dart';
import 'page/live_streaming_page.dart';
import 'theme/colors.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({
    Key? key,
  }) : super(key: key);

  @override
  _BottomNavbarState createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CategoryPage());
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({
    Key? key,
  }) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GlobalKey _bottomNavigationKey = GlobalKey();
  int selectedIndex = 0;

  final List<Widget> listPage = [
    const HomePage(),
    const ClassRoomPage(),
    const LiveStreamingPage(),
    const DelayStreamingPage(),
    const DownloadPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listPage.elementAt(selectedIndex),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 48,
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 24,
            color: kWhite,
          ),
          Icon(
            Icons.class_rounded,
            size: 24,
            color: kWhite,
          ),
          Icon(
            Icons.live_tv,
            size: 24,
            color: kWhite,
          ),
          Icon(
            Icons.timelapse,
            size: 24,
            color: kWhite,
          ),
          Icon(
            Icons.download,
            size: 24,
            color: kWhite,
          ),
        ],
        color: kCelticBlue,
        buttonBackgroundColor: kCelticBlue,
        backgroundColor: kWhite,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 200),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
