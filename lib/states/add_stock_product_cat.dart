import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/stock_model.dart';
import 'package:frongeasyshop/utility/my_constant.dart';

class AddStockProductCat extends StatefulWidget {
  const AddStockProductCat({Key? key}) : super(key: key);

  @override
  _AddStockProductCatState createState() => _AddStockProductCatState();
}

class _AddStockProductCatState extends State<AddStockProductCat> {
  final formKey = GlobalKey<FormState>();
  TextEditingController groupControllor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primart,
        title: const Text('เพิ่มกลุ่มของสินค้า'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            children: [buildgroup(), buildAddgroup()],
          ),
        ),
      ),
    );
  }

  Container buildAddgroup() {
    return Container(
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            checkOrAddGroup();
          }
        },
        child: Text('Add Group'),
      ),
    );
  }

  Future<void> checkOrAddGroup() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(event!.uid)
          .collection('stock')
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          processAddGroup(event.uid);
        } else {
          //ตรวจสอบว่า กลุ่มซ้ำไหม?
          processAddGroup(event.uid);
        }
      });
    });
  }

  Future<void> processAddGroup(String docId) async {
    StockModel model = StockModel(cat: groupControllor.text);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(docId)
        .collection('stock')
        .doc()
        .set(model.toMap())
        .then((value) => Navigator.pop(context));
  }

  Container buildgroup() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: 250,
      child: TextFormField(
        controller: groupControllor,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาเพิ่มชื่อกลุ่มสินค้า';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          label: Text('เพิ่มกลุ่มของสินค้า'),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
