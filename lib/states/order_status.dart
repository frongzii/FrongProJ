import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';

class OrderStatus extends StatefulWidget {
  const OrderStatus({Key? key}) : super(key: key);

  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primart,
        title: const Text('สถานะคำสั่งซื้อ'),
      ),
    );
  }
}
