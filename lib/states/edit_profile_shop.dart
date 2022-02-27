import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/profile_shop_model.dart';
import 'package:frongeasyshop/utility/my_dialog.dart';
import 'package:frongeasyshop/widgets/show_form.dart';
import 'package:frongeasyshop/widgets/show_process.dart';

class EditProfileShop extends StatefulWidget {
  final String? docIdProfile;
  const EditProfileShop({Key? key, this.docIdProfile}) : super(key: key);

  @override
  _EditProfileShopState createState() => _EditProfileShopState();
}

class _EditProfileShopState extends State<EditProfileShop> {
  ProfileShopModel? profileShopModel;

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> map = {};
  String? docIdProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    docIdProfile = widget.docIdProfile;
    print('@@ docIdProfile ==>> $docIdProfile');

    readCurrentProfile();
  }

  Future<void> readCurrentProfile() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(event!.uid)
          .collection('profile')
          .get()
          .then((value) {
        for (var item in value.docs) {
          setState(() {
            profileShopModel = ProfileShopModel.fromMap(item.data());
            nameController.text = profileShopModel!.nameShop;
            addressController.text = profileShopModel!.address;
            phoneController.text = profileShopModel!.phone;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูล ร้านค้า'),
      ),
      body: profileShopModel == null
          ? const ShowProcess()
          : GestureDetector(
              onTap: () =>
                  FocusScope.of(context).requestFocus(FocusScopeNode()),
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      ShowForm(
                        title: 'ชื่อร้าน :',
                        myValidate: nameValidate,
                        mySave: nameSave,
                        textEditingController: nameController,
                      ),
                      ShowForm(
                        title: 'ที่อยู่ :',
                        myValidate: addressValidate,
                        mySave: addressSave,
                        textEditingController: addressController,
                      ),
                      ShowForm(
                        title: 'เบอร์โทรศัพย์ :',
                        myValidate: phoneValidate,
                        mySave: phoneSave,
                        textEditingController: phoneController,
                      ),
                      buttonEditShop(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  SizedBox buttonEditShop() {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            print('@@ map ==> $map');

            if (map.isEmpty) {
              MyDialog().normalDialog(
                  context, 'Not Change', 'ไม่มีการเปลียน อะไร ? เลย');
            } else {
              await FirebaseAuth.instance
                  .authStateChanges()
                  .listen((event) async {
                await FirebaseFirestore.instance
                    .collection('user')
                    .doc(event!.uid)
                    .collection('profile')
                    .doc(docIdProfile)
                  

                    .update(map)
                    .then((value) => Navigator.pop(context))
                    .catchError((value) {
                  print('@@ error ==>> $value');
                });
              });
            }
          }
        },
        child: const Text('Edit Shop'),
      ),
    );
  }

  void nameSave(String? string) {
    if (string != profileShopModel!.nameShop) {
      print('name ใหม่ ==> $string');
      map['nameShop'] = string;
    }
  }

  String? nameValidate(String? string) {
    if (string!.isEmpty) {
      return 'กรุณากรอกชื่อ';
    } else {
      return null;
    }
  }

  void addressSave(String? string) {
    if (string != profileShopModel!.address) {
      map['address'] = string;
    }
  }

  String? addressValidate(String? string) {
    if (string!.isEmpty) {
      return 'กรุณากรอกที่อยู่';
    } else {
      return null;
    }
  }

  void phoneSave(String? string) {
    if (string != profileShopModel!.phone) {
      map['phone'] = string;
    }
  }

  String? phoneValidate(String? string) {
    if (string!.isEmpty) {
      return 'กรุณากรอกเบอร์ ด้วยคะ';
    } else {
      return null;
    }
  }
}
