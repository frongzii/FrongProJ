import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ShowImage extends StatelessWidget {
  const ShowImage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset('images/pic.svg');
  }
}