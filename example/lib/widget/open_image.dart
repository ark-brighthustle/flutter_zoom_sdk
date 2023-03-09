import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../utils/constant.dart';

class OpenImagePage extends StatefulWidget {
  final String title, img;
  const OpenImagePage({Key? key, required this.title, required this.img}) : super(key: key);

  @override
  State<OpenImagePage> createState() => _OpenImagePageState();
}

class _OpenImagePageState extends State<OpenImagePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBlack,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Row(
              children: [
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: kWhite,), padding: const EdgeInsets.only(top: 40),),
                const SizedBox(width: 16,),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(widget.title, style: TextStyle(color: kWhite,fontSize: 18),),
                )
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width,
                  height: size.height/2,
                  decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(widget.img), fit: BoxFit.cover)
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}