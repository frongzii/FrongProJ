import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/product_model.dart';
import 'package:frongeasyshop/models/stock_model.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/utility/my_dialog.dart';
import 'package:frongeasyshop/widgets/show_svg.dart';
import 'package:frongeasyshop/widgets/show_text.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  final StockModel stockModel;
  final String docStock;
  const AddProduct({Key? key, required this.stockModel, required this.docStock})
      : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  StockModel? stockModel;
  File? file;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameProductController = TextEditingController();
  TextEditingController amountProductController = TextEditingController();
  TextEditingController priceProductController = TextEditingController();
  String? docStock, uidUserLogin;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stockModel = widget.stockModel;
    docStock = widget.docStock;
    findUidUser();
  }

  Future<void> findUidUser() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) {
      uidUserLogin = event!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primart,
        title: Text('เพิ่มสินค้า ในกลุ่ม ${stockModel!.cat}'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusScopeNode(),
        ),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildImage(),
                buildName(),
                buildStock(),
                buildPrice(),
                buildSave(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildSave() {
    return Container(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            if (file == null) {
              MyDialog().normalDialog(context, 'ยังไม่มีรูปภาพ',
                  'กรุณา ถ่ายภาพ หรือ เลือกรูปจากคลังภาพ ด้วยคะ');
            } else {
              processUploadAndInsertProduct();
            }
          }
        },
        child: Text('Save'),
        style: MyConstant().myButtonStyle(),
      ),
    );
  }

  Container buildPrice() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก ราคาสินค้า';
          } else {
            return null;
          }
        },
        controller: priceProductController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          label: ShowText(title: 'ราคาของสินค้า'),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildName() {
    return Container(
      width: 250,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก ชือสินค้า';
          } else {
            return null;
          }
        },
        controller: nameProductController,
        decoration: const InputDecoration(
          label: ShowText(title: 'ชื่อสินค้า'),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildStock() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: 250,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก จำนวนสินค้า';
          } else {
            return null;
          }
        },
        controller: amountProductController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          label: ShowText(title: 'จำนวนสินค้า'),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> processTakePhoto(ImageSource source) async {
    try {
      var result = await ImagePicker()
          .pickImage(source: source, maxWidth: 800, maxHeight: 800);
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => processTakePhoto(ImageSource.camera),
          icon: const Icon(Icons.add_a_photo),
        ),
        Container(
          width: 150,
          height: 150,
          child: file == null ? const ShowImage() : Image.file(file!),
        ),
        IconButton(
          onPressed: () => processTakePhoto(ImageSource.gallery),
          icon: const Icon(Icons.add_photo_alternate),
        ),
      ],
    );
  }

  Future<void> processUploadAndInsertProduct() async {
    String nameFile = 'product${Random().nextInt(1000000)}.jpg';
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child('Product/$nameFile');
    UploadTask task = reference.putFile(file!);
    await task.whenComplete(() async {
      await reference.getDownloadURL().then((value) async {
        var path = value.toString();
        print('path ==> $path');

        ProductModel model = ProductModel(
            nameProduct: nameProductController.text,
            amountProduct: int.parse(amountProductController.text.trim()),
            priceProduct: int.parse(priceProductController.text.trim()),
            pathProduct: path);

        await FirebaseFirestore.instance
            .collection('user')
            .doc(uidUserLogin)
            .collection('stock')
            .doc(docStock)
            .collection('product')
            .doc()
            .set(model.toMap())
            .then((value) async {
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uidUserLogin)
              .collection('profile')
              .get()
              .then((value) async {
            for (var item in value.docs) {
              var docIdProfile = item.id;
              Map<String, dynamic> map = {};
              map['product'] = true;
              await FirebaseFirestore.instance
                  .collection('user')
                  .doc(uidUserLogin)
                  .collection('profile')
                  .doc(docIdProfile)
                  .update(map)
                  .then((value) => Navigator.pop(context));
            }
          });
        });
      });
    });
  }
}
