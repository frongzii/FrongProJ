// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/product_model.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/widgets/show_process.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class ShowProductForShoper extends StatefulWidget {
  final String docStock;
  final String docUser;
  const ShowProductForShoper({
    Key? key,
    required this.docStock,
    required this.docUser,
  }) : super(key: key);

  @override
  State<ShowProductForShoper> createState() => _ShowProductForShoperState();
}

class _ShowProductForShoperState extends State<ShowProductForShoper> {
  String? docUser, docStock;
  bool load = true;
  var productModels = <ProductModel>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docUser = widget.docUser;
    docStock = widget.docStock;
    readData();
  }

  Future<void> readData() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docUser)
        .collection('stock')
        .doc(docStock)
        .collection('product')
        .get()
        .then((value) {
      for (var item in value.docs) {
        ProductModel productModel = ProductModel.fromMap(item.data());
        productModels.add(productModel);
      }

      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primart,
        title: Text('สินค้า'),
      ),
      body: load
          ? const ShowProcess(
        
          )
          
          : ListView.builder(
              itemCount: productModels.length,
              itemBuilder: (context, index) =>
                  ShowText(title: productModels[index].nameProduct),
            ),
    );
  }
}
