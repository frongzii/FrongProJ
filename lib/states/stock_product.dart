import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class StockProduct extends StatefulWidget {
  const StockProduct({Key? key}) : super(key: key);

  @override
  _StockProductState createState() => _StockProductState();
}

class _StockProductState extends State<StockProduct> {
  List<String> titles = [
    'คลังสินค้า',
    'สินค้าใกล้หมดอายุ',
    'สินค้าขาดสต็อก',
    'สินค้าขายดี',
  ];

  List<String> routeProduct = [
    MyConstant.routStockProductCatigory,
    '',
    '',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primart,
        title: const Text('การสต๊อกสินค้า'),
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
