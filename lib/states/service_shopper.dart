import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/widgets/show_signout.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class ServiceShopper extends StatefulWidget {
  const ServiceShopper({Key? key}) : super(key: key);

  @override
  _ServiceShopperState createState() => _ServiceShopperState();
}

class _ServiceShopperState extends State<ServiceShopper> {
  List<String> titles = [
    'แก้ไขข้อมูลร้านค้า',
    'การสต๊อกสินค้า',
    'การจัดโปรโมชั่น',
    'ประวัติรายการสั่งซื้อ',
    'สถานะคำสั่งซื้อ',
    'ติดต่อลูกค้า',
  ];

  List<String> routeProduct = [
    MyConstant.routEditShopProFile,
    MyConstant.routStockProduct,
    MyConstant.routStockPromotion,
    MyConstant.routOrderHistory,
    MyConstant.routOrderStatus,
    MyConstant.routContactCustomer,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primart,
        title: const Text('ส่วนของร้านค้า'),
        actions: [ShowSignOut()],
      ),
      body: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            if (routeProduct[index].isNotEmpty) {
              Navigator.pushNamed(context, routeProduct[index]);
            }
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
