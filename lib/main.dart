import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/models/user_mdel.dart';
import 'package:frongeasyshop/states/add_stock_product_cat.dart';
import 'package:frongeasyshop/states/authen.dart';
import 'package:frongeasyshop/states/contact_customer.dart';
import 'package:frongeasyshop/states/create_account.dart';
import 'package:frongeasyshop/states/edit_profile_shop.dart';
import 'package:frongeasyshop/states/edit_shop_profile.dart';
import 'package:frongeasyshop/states/forgotpassword.dart';
import 'package:frongeasyshop/states/insert_profile_shop.dart';
import 'package:frongeasyshop/states/order_history.dart';
import 'package:frongeasyshop/states/order_status.dart';
import 'package:frongeasyshop/states/promotion.dart';
import 'package:frongeasyshop/states/service_buyer.dart';
import 'package:frongeasyshop/states/service_shopper.dart';
import 'package:frongeasyshop/states/show_shop_for_buyer.dart';
import 'package:frongeasyshop/states/stock_product.dart';
import 'package:frongeasyshop/states/stock_product_catigory.dart';
import 'package:frongeasyshop/utility/my_constant.dart';

Map<String, WidgetBuilder> map = {
  MyConstant.routAuthen: (BuildContext context) => const Authen(),
  MyConstant.routCreateAccount: (BuildContext context) => const CreateAccount(),
  MyConstant.routServiceBuyer: (BuildContext context) => const ServiceBuyer(),
  MyConstant.routServiceShopper: (BuildContext context) =>
      const ServiceShopper(),
  MyConstant.routForgotPassword: (BuildContext context) =>
      const ForgotPassword(),
  MyConstant.routStockProduct: (BuildContext context) => const StockProduct(),
  MyConstant.routEditShopProFile: (BuildContext context) =>
      const EditShopProFile(),
  MyConstant.routStockProductCatigory: (BuildContext context) =>
      const StockProductCatigory(),
  MyConstant.routStockAddStockProductCat: (BuildContext context) =>
      const AddStockProductCat(),
  MyConstant.routStockPromotion: (BuildContext context) => const Promotion(),
  MyConstant.routOrderHistory: (BuildContext context) => const OrderHistory(),
  MyConstant.routOrderStatus: (BuildContext context) => const OrderStatus(),
  MyConstant.routContactCustomer: (BuildContext context) =>
      const ContactCustomer(),
  MyConstant.routShowShopForBuyer: (BuildContext context) =>
      const ShowShopForBuyer(),
  MyConstant.routInsertProfileShop: (BuildContext context) =>
      const InsertProfileShop(),
  MyConstant.routEditProfileShop: (BuildContext context) =>
      const EditProfileShop(),
};

String? firstState;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    print('initial Success');
    await FirebaseAuth.instance.authStateChanges().listen((event) async {
      if (event != null) {
        String uid = event.uid;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .get()
            .then((value) {
          UserModel model = UserModel.fromMap(value.data()!);
          switch (model.typeuser) {
            case 'buyer':
              firstState = MyConstant.routServiceBuyer;
              runApp(const MyApp());
              break;
            case 'shopper':
              firstState = MyConstant.routServiceShopper;
              runApp(const MyApp());
              break;
            default:
          }
        });
      } else {
        firstState = MyConstant.routAuthen;
        runApp(const MyApp());
      }
    });
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: map,
      initialRoute: firstState,
    );
  }
}
