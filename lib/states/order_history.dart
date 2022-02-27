import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primart,
        title: const Text('ประวัติรายการสั่งซื้อ'),
      ),
    );
  }
}
