import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';

class WorkshopPage extends StatefulWidget {
  const WorkshopPage({Key? key}) : super(key: key);

  @override
  State<WorkshopPage> createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(
          child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: itemEventWorkshopList(),
      )),
    );
  }

  Widget itemEventWorkshopList() {
    return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Row(
          children: [
            IconButton(
              padding: const EdgeInsets.only(left: padding),
              onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, size: 20,)),
            const Padding(
              padding: EdgeInsets.only(left: padding),
              child: Text(titleWorkshop, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
            ),
          ],
        ),
      ],
    );
  }
}