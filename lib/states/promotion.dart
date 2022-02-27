import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';

class Promotion extends StatefulWidget {
  const Promotion({Key? key}) : super(key: key);

  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primart,
        title: const Text('การจัดโปรโมชั่น'),
      ),
    );
  }
}
