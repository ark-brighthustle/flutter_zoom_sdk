import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../utils/constant.dart';

class FotoProfilPage extends StatefulWidget {
  final String foto;
  const FotoProfilPage({Key? key, required this.foto}) : super(key: key);

  @override
  State<FotoProfilPage> createState() => _FotoProfilPageState();
}

class _FotoProfilPageState extends State<FotoProfilPage> {
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
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(titleFotoProfil, style: TextStyle(color: kWhite,fontSize: 18),),
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
                    image: DecorationImage(image: NetworkImage(widget.foto), fit: BoxFit.cover)
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