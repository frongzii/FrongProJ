// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/product_model.dart';
import 'package:frongeasyshop/models/sqlite_model.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/utility/my_dialog.dart';
import 'package:frongeasyshop/utility/sqlite_helper.dart';
import 'package:frongeasyshop/widgets/show_add_cart.dart';
import 'package:frongeasyshop/widgets/show_image_from_url.dart';
import 'package:frongeasyshop/widgets/show_logo.dart';
import 'package:frongeasyshop/widgets/show_process.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class ShowListProductWhereCat extends StatefulWidget {
  final String idStock;
  final String idUser;
  const ShowListProductWhereCat({
    Key? key,
    required this.idStock,
    required this.idUser,
  }) : super(key: key);

  @override
  State<ShowListProductWhereCat> createState() =>
      _ShowListProductWhereCatState();
}

class _ShowListProductWhereCatState extends State<ShowListProductWhereCat> {
  String? idStock, idDocUser;
  var productModels = <ProductModel>[];
  var docProducts = <String>[];
  bool load = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idStock = widget.idStock;
    idDocUser = widget.idUser;
    print('idStock ==>> $idStock');
    readAllProduct();
  }

  Future<void> readAllProduct() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(idDocUser)
        .collection('stock')
        .doc(idStock)
        .collection('product')
        .get()
        .then((value) {
      for (var item in value.docs) {
        ProductModel productModel = ProductModel.fromMap(item.data());
        productModels.add(productModel);
        docProducts.add(item.id);
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
        title: Text('รายการสินค้า'),
        actions: [
          ShowAddCart(callBackFunc: () {
            print('################### Call Back Work');
            readAllProduct();
          }),
        ],
      ),
      body: load
          ? const ShowProcess()
          : ListView.builder(
              itemCount: productModels.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () =>
                    dialogAddCart(productModels[index], docProducts[index]),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShowImageFromUrl(
                          path: productModels[index].pathProduct,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ShowText(
                              title: productModels[index].nameProduct,
                              textStyle: MyConstant().h2Style(),
                            ),
                            ShowText(
                              title:
                                  'ราคา ${productModels[index].priceProduct.toString()} บาท',
                              textStyle: MyConstant().h3Style(),
                            ),
                            ShowText(
                              title:
                                  'จำนวน คงเหลือ = ${productModels[index].amountProduct.toString()}',
                              textStyle: MyConstant().h3Style(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Future<void> dialogAddCart(
      ProductModel productModel, String docProduct) async {
    int chooseProduct = 1;
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: ListTile(
            leading: const ShowLogo(),
            title: ShowText(
              title: productModel.nameProduct,
              textStyle: MyConstant().h2Style(),
            ),
            subtitle: Column(
              children: [
                ShowText(
                    title:
                        'ราคา = ${productModel.priceProduct.toString()} บาท'),
                ShowText(
                    title:
                        'จำนวนคงเหลือ = ${productModel.amountProduct.toString()} '),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShowImageFromUrl(path: productModel.pathProduct),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: () {
                        if (chooseProduct < productModel.amountProduct) {
                          chooseProduct++;
                          print('chooseProduct ==>> $chooseProduct');
                        }
                        setState(() {});
                      },
                      icon: const Icon(Icons.add_circle)),
                  ShowText(
                    title: '$chooseProduct',
                    textStyle: MyConstant().h1Style(),
                  ),
                  IconButton(
                      onPressed: () {
                        if (chooseProduct > 1) {
                          chooseProduct--;
                        }
                        setState(() {});
                      },
                      icon: const Icon(Icons.remove_circle)),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  Navigator.pop(context);

                  await SQLiteHelper().readAllData().then((value) {
                    var sqliteModels = <SQLiteModel>[];
                    sqliteModels = value;
                    if (value.isEmpty) {
                      processAddCart(productModel, chooseProduct, docProduct);
                    } else {
                      if (sqliteModels[0].docUser == idDocUser) {
                        processAddCart(productModel, chooseProduct, docProduct);
                      } else {
                        MyDialog().normalDialog(
                            context, 'ผิดร้าน', 'กรุณา เพิ่มสินค้าที่เราเดิม');
                      }
                    }
                  });
                },
                child: const Text('เพิ่มลงตะกร้า')),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('ยกเลิก')),
          ],
        );
      }),
    );
  }

  Future<void> processAddCart(
      ProductModel productModel, int chooseProduct, String docProduct) async {
    print(
        'add ==> ${productModel.nameProduct} chooseProduct ==> $chooseProduct');

    SQLiteModel sqLiteModel = SQLiteModel(
        nameProduct: productModel.nameProduct,
        price: productModel.priceProduct.toString(),
        amount: chooseProduct.toString(),
        sum: (productModel.priceProduct * chooseProduct).toString(),
        docProduct: docProduct,
        docStock: idStock!,
        docUser: idDocUser!);

    await SQLiteHelper().insertValueToSQLite(sqLiteModel).then((value) =>
        MyDialog().normalDialog(context, 'เพิ่มลงตะกร้า',
            'เพิ่ม ${productModel.nameProduct} สำเร็จ'));
  }
}
