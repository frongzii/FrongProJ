import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/profile_shop_model.dart';
import 'package:frongeasyshop/states/edit_profile_shop.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/widgets/show_process.dart';
import 'package:frongeasyshop/widgets/show_text.dart';
//import 'package:frongeasyshop/widgets/show_signout.dart';

class EditShopProFile extends StatefulWidget {
  const EditShopProFile({Key? key}) : super(key: key);

  @override
  _EditShopProFileState createState() => _EditShopProFileState();
}

class _EditShopProFileState extends State<EditShopProFile> {
  var load = true;
  String? uidLogin, docIdProfile;
  bool? haveProfile;

  ProfileShopModel? profileShopModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readProfileShop();
  }

  Future<void> readProfileShop() async {
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      uidLogin = event!.uid;
      await FirebaseFirestore.instance
          .collection('user')
          .doc(uidLogin)
          .collection('profile')
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          setState(() {
            haveProfile = false;
            load = false;
          });
        } else {
          for (var item in value.docs) {
            docIdProfile = item.id;
            setState(() {
              profileShopModel = ProfileShopModel.fromMap(item.data());
            });
          }

          setState(() {
            haveProfile = true;
            load = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          haveProfile == null ? const SizedBox() : buttonInsertOrEdit(context),
      appBar: AppBar(
        backgroundColor: MyConstant.primart,
        title: const Text('แก้ไขข้อมูลร้านค้า'),
      ),
      body: load
          ? const ShowProcess()
          : haveProfile!
              ? profileShopModel == null
                  ? const ShowProcess()
                  : Center(
                      child: Column(
                        children: [
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.network(profileShopModel!.pathImage),
                          ),
                          ShowText(
                            title: profileShopModel!.nameShop,
                            textStyle: MyConstant().h2Style(),
                          ),
                          ShowText(
                            title: profileShopModel!.address,
                            textStyle: MyConstant().h2Style(),
                          ),
                        ],
                      ),
                    )
              : Center(
                  child: ShowText(
                  title: 'No Profile',
                  textStyle: MyConstant().h1Style(),
                )),
    );
  }

  ElevatedButton buttonInsertOrEdit(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (haveProfile!) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfileShop(
                  docIdProfile: docIdProfile,
                ),
              )).then((value) => readProfileShop());
        } else {
          Navigator.pushNamed(context, MyConstant.routInsertProfileShop)
              .then((value) => readProfileShop());
        }
      },
      child: haveProfile!
          ? const Text('Edit Profile')
          : const Text('Insert Profile'),
    );
  }
}
