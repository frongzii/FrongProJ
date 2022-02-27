import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';

class ShowText extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  const ShowText({Key? key, required this.title, this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: textStyle == null ? MyConstant().h3Style(): textStyle! ,);
  }
}
