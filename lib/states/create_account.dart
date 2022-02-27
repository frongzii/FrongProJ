import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/user_mdel.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/utility/my_dialog.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  String? typeUser;
  final formkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Container buildCreateAccount() {
    return Container(
      width: 250,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          if (formkey.currentState!.validate()) {
            if (typeUser == null) {
              MyDialog().normalDialog(
                  context, 'ไม่มีชนิดผู้ใช้งาน', 'โปรอดเลือกชนิดของผู้ใช้งาน');
            } else {
              processRegisterAndInsertUser();
            }
          }
        },
        child: Text('สร้างบัญชีใหม่'),
      ),
    );
  }

  Future<void> processRegisterAndInsertUser() async {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    print([name, email, password, typeUser]);

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      print('## สมัครสำเร็จ');
      String uid = value.user!.uid;
      print('## uid ที่สมัครสำเร็จ = $uid');

      UserModel model = UserModel(
          email: email, name: name, password: password, typeuser: typeUser!);

      await FirebaseFirestore.instance
          .collection('user')
          .doc(uid)
          .set(model.toMap())
          .then((value) => Navigator.pop(context));

    }).catchError((value) {
      String error = value.code;
      String detail = value.message;
      print('## error = $error, detail = $detail');
      MyDialog().normalDialog(context, error, detail);
    });
  }

  Container buildName() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      width: 250,
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก ผู้ใช้งาน?';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.fingerprint),
          label: ShowText(
            title: 'ชื่อผู้ใช้งาน :',
            textStyle: MyConstant().h2Style(),
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildEmail() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: 250,
      child: TextFormField(
        controller: emailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก Email ผู้ใช้งาน?';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.email_outlined),
          label: ShowText(
            title: 'Email ผู้ใช้งาน :',
            textStyle: MyConstant().h2Style(),
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      width: 250,
      child: TextFormField(
        controller: passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก รหัสผ่าน?';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline),
          label: ShowText(
            title: 'รหัสผ่าน :',
            textStyle: MyConstant().h2Style(),
          ),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('สร้างบัญชีใหม่'),
        backgroundColor: MyConstant.primart,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: ListView(
            children: [
              Form(
                key: formkey,
                child: Column(
                  children: [
                    buildName(),
                    buildTitle(),
                    buildType(),
                    buildEmail(),
                    buildPassword(),
                    buildCreateAccount(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildType() {
    return Container(
      width: 300,
      child: Row(
        children: [
          Container(
            width: 150,
            child: RadioListTile(
              title: ShowText(title: 'ลูกค้า'),
              value: 'buyer',
              groupValue: typeUser,
              onChanged: (value) {
                setState(() {
                  typeUser = value.toString();
                });
              },
            ),
          ),
          Container(
            width: 150,
            child: RadioListTile(
              title: ShowText(title: 'เจ้าของร้าน'),
              value: 'shopper',
              groupValue: typeUser,
              onChanged: (value) {
                setState(() {
                  typeUser = value.toString();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Container buildTitle() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: 250,
      child: Row(
        children: [
          ShowText(
            title: 'ชนิดของผู้ใช้งาน :',
            textStyle: MyConstant().h2Style(),
          ),
        ],
      ),
    );
  }
}
