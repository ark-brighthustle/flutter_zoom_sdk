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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(
          child: SizedBox(
        width: size.width,
        height: size.height,
        child: itemEventWorkshopList(),
      )),
    );
  }

  Widget itemEventWorkshopList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(8, 12, 0, 12),
          child: Row(
            children: [
              IconButton(
                  padding: const EdgeInsets.only(left: padding, right: padding),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 20,
                  )),
              const Text(
                titleWorkshop,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
