import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/widgets/show_signout.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class ServiceBuyer extends StatefulWidget {
  const ServiceBuyer({Key? key}) : super(key: key);

  @override
  _ServiceBuyerState createState() => _ServiceBuyerState();
}

class _ServiceBuyerState extends State<ServiceBuyer> {
  var titles = <String>[
    'ข้อมูลส่วนตัว',
    'ติดต่อร้านค้า',
    'สถานะสินค้า',
    'เลือกร้านค้า',
    'โปรโมชั่นแนะนำ',
  ];

  var keyRoutes = <String>[
    '',
    '',
    '',
    MyConstant.routShowShopForBuyer,
    '',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [ShowSignOut()],
        backgroundColor: MyConstant.primart,
        title: const Text('ส่วนของลูกค้า'),
      ),
      body: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            if (keyRoutes[index].isNotEmpty) {
              Navigator.pushNamed(context, keyRoutes[index]);
            }
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ShowText(
                title: titles[index],
                textStyle: MyConstant().h2Style(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
