import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/product_model.dart';
import 'package:frongeasyshop/models/profile_shop_model.dart';
import 'package:frongeasyshop/models/sqlite_model.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/utility/sqlite_helper.dart';
import 'package:frongeasyshop/widgets/show_process.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class DisplayCart extends StatefulWidget {
  const DisplayCart({
    Key? key,
  }) : super(key: key);

  @override
  State<DisplayCart> createState() => _DisplayCartState();
}

class _DisplayCartState extends State<DisplayCart> {
  bool load = true;
  bool? haveData;
  var sqliteModels = <SQLiteModel>[];
  ProfileShopModel? profileShopModel;
  int total = 0;

  @override
  void initState() {
    super.initState();
    readSQLite();
  }

  Future<void> readSQLite() async {
    if (sqliteModels.isNotEmpty) {
      sqliteModels.clear();
      total = 0;
    }
    await SQLiteHelper().readAllData().then((value) async {
      print('value readSQLite ==> $value');

      if (value.isEmpty) {
        haveData = false;
      } else {
        haveData = true;

        for (var item in value) {
          SQLiteModel sqLiteModel = item;
          sqliteModels.add(sqLiteModel);
          total = total + int.parse(sqLiteModel.sum);
        }

        await FirebaseFirestore.instance
            .collection('user')
            .doc(sqliteModels[0].docUser)
            .collection('profile')
            .get()
            .then((value) {
          for (var item in value.docs) {
            setState(() {
              profileShopModel = ProfileShopModel.fromMap(item.data());
            });
          }
        });
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
        title: const Text('Display Cart'),
      ),
      body: load
          ? const ShowProcess()
          : haveData!
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowText(
                      title: profileShopModel!.nameShop,
                      textStyle: MyConstant().h1Style(),
                    ),
                    ShowText(
                      title: profileShopModel!.address,
                      textStyle: MyConstant().h3Style(),
                    ),
                    showHead(),
                    listCart(),
                    const Divider(
                      color: Colors.blue,
                    ),
                    newTotal(),
                    newControlButton(),
                  ],
                )
              : Center(
                  child: ShowText(
                    title: 'ยังไม่มี สินค้าใน ตะกร้า',
                    textStyle: MyConstant().h2Style(),
                  ),
                ),
    );
  }

  Row newControlButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () async {
              await SQLiteHelper()
                  .deleteAllData()
                  .then((value) => readSQLite());
            },
            child: const Text('Empty Cart')),
        const SizedBox(
          width: 4,
        ),
        ElevatedButton(
            onPressed: () async {
              for (var item in sqliteModels) {
                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(item.docUser)
                    .collection('stock')
                    .doc(item.docStock)
                    .collection('product')
                    .doc(item.docProduct)
                    .get()
                    .then((value) async {
                  ProductModel productModel =
                      ProductModel.fromMap(value.data()!);
                  int newAmountProduct =
                      productModel.amountProduct - int.parse(item.amount);

                  Map<String, dynamic> data = {};
                  data['amountProduct'] = newAmountProduct;

                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(item.docUser)
                      .collection('stock')
                      .doc(item.docStock)
                      .collection('product')
                      .doc(item.docProduct)
                      .update(data)
                      .then((value) =>
                          print('Success Update ${item.nameProduct}'));
                });
              }
              await SQLiteHelper()
                  .deleteAllData()
                  .then((value) => readSQLite());
            },
            child: const Text('Order')),
        const SizedBox(
          width: 4,
        ),
      ],
    );
  }

  Row newTotal() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowText(
                title: 'Total : ',
                textStyle: MyConstant().h2Style(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ShowText(
            title: '$total',
            textStyle: MyConstant().h2Style(),
          ),
        ),
      ],
    );
  }

  Container showHead() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade300),
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ShowText(
              title: 'ชื่อสินค้า',
              textStyle: MyConstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowText(
              title: 'ราคา',
              textStyle: MyConstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowText(
              title: 'จำนวน',
              textStyle: MyConstant().h2Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowText(
              title: 'รวม',
              textStyle: MyConstant().h2Style(),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  ListView listCart() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 3,
            child: ShowText(title: sqliteModels[index].nameProduct),
          ),
          Expanded(
            flex: 1,
            child: ShowText(title: sqliteModels[index].price),
          ),
          Expanded(
            flex: 1,
            child: ShowText(title: sqliteModels[index].amount),
          ),
          Expanded(
            flex: 1,
            child: ShowText(title: sqliteModels[index].sum),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () async {
                await SQLiteHelper()
                    .deleteValueFromId(sqliteModels[index].id!)
                    .then((value) => readSQLite());
              },
              icon: const Icon(Icons.delete_forever),
            ),
          ),
        ],
      ),
    );
  }
}
