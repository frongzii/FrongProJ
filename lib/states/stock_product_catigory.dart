import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/stock_model.dart';
import 'package:frongeasyshop/states/add_product.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/widgets/show_process.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class StockProductCatigory extends StatefulWidget {
  const StockProductCatigory({Key? key}) : super(key: key);

  @override
  _StockProductCatigoryState createState() => _StockProductCatigoryState();
}

class _StockProductCatigoryState extends State<StockProductCatigory> {
  bool load = true;
  bool? haveStock;
  List<StockModel> stockModels = [];
  var docStocks = <String>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readStock();
  }

  Future<void> readStock() async {
    if (stockModels.isNotEmpty) {
      stockModels.clear();
    }

    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      String uid = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .collection('stock')
          .get()
          .then((value) {
        print('## value Strock = ${value.docs.length}');

        if (value.docs.isEmpty) {
          setState(() {
            haveStock = false;
            load = false;
          });
        } else {
          for (var item in value.docs) {
            StockModel model = StockModel.fromMap(item.data());
            setState(() {
              stockModels.add(model);
              docStocks.add(item.id);
              haveStock = true;
              load = false;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
                    context, MyConstant.routStockAddStockProductCat)
                .then((value) => readStock()),
            icon: const Icon(Icons.add_box),
          ),
        ],
        backgroundColor: MyConstant.primart,
        title: const Text('คลังสินค้า(กลุ่มของสินค้า)'),
      ),
      body: load
          ? const ShowProcess()
          : haveStock!
              ? buildListType()
              : Center(
                  child: ShowText(
                    title: 'ยังไม่มีกลุ่มสินค้า',
                    textStyle: MyConstant().h1Style(),
                  ),
                ),
    );
  }

  ListView buildListType() {
    return ListView.builder(
      itemCount: stockModels.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduct(
                stockModel: stockModels[index],
                docStock: docStocks[index],
              ),
            )),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ShowText(
              title: stockModels[index].cat,
              textStyle: MyConstant().h2Style(),
            ),
          ),
        ),
      ),
    );
  }
}
