// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
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
      }

      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: load
          ? const ShowProcess()
          : haveProduct!
              ? Text('Have Data')
              : Center(
                  child: ShowText(
                  title: 'ยังไม่มีสินค้า',
                  textStyle: MyConstant().h1Style(),
                )),
    );
  }
}
