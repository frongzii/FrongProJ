// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/stock_model.dart';
import 'package:frongeasyshop/states/show_list_product_where_cat.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/widgets/show_add_cart.dart';
import 'package:frongeasyshop/widgets/show_process.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class ShowProductWhereShop extends StatefulWidget {
  final String idDocUser;
  const ShowProductWhereShop({
    Key? key,
    required this.idDocUser,
  }) : super(key: key);

  @override
  State<ShowProductWhereShop> createState() => _ShowProductWhereShopState();
}

class _ShowProductWhereShopState extends State<ShowProductWhereShop> {
  String? idDocUser;
  bool load = true;
  bool? haveProduct;
  var stockModels = <StockModel>[];
  var idStocks = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idDocUser = widget.idDocUser;
    readProduct();
  }

  Future<void> readProduct() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(idDocUser)
        .collection('stock')
        .get()
        .then((value) {
      print('value ==>> ${value.docs}');

      if (value.docs.isEmpty) {
        haveProduct = false;
      } else {
        haveProduct = true;
        for (var item in value.docs) {
          StockModel stockModel = StockModel.fromMap(item.data());
          stockModels.add(stockModel);

          idStocks.add(item.id);
        }
      }

      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [ShowAddCart()],
      backgroundColor: MyConstant.primart,
      title: Text('สินค้า'),),
      body: load
          ? const ShowProcess()
          : haveProduct!
              ? ListView.builder(
                  itemCount: stockModels.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowListProductWhereCat(idStock: idStocks[index], idUser: idDocUser!,),
                        )),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ShowText(title: stockModels[index].cat),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: ShowText(
                  title: 'ยังไม่มีสินค้า',
                  textStyle: MyConstant().h1Style(),
                )),
    );
  }
}
