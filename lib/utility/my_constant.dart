import 'package:flutter/material.dart';

class MyConstant {
  //field
  static String routAuthen = '/authen';
  static String routCreateAccount = '/createBccount';
  static String routServiceBuyer = '/serviceBuyer';
  static String routServiceShopper = '/serviceShopper';
  static String routForgotPassword = '/forgotPassword';
  static String routStockProduct = '/stockProduct';
  static String routEditShopProFile = '/editShopProFile';
  static String routStockProductCatigory = '/stockProductCatigoty';
  static String routStockAddStockProductCat = '/addStockProductCat';
  static String routStockPromotion = '/proMoTion';
  static String routOrderHistory = '/orderHistory';
  static String routOrderStatus = '/orderStatus';
  static String routContactCustomer = '/contactCustomer';
  static String routShowShopForBuyer = '/showShopForBuyer';
  static String routInsertProfileShop = '/insertProfileShop';
  static String routEditProfileShop = '/editProfileShop';

  static Color primart = const Color(0xffa08a59);
  static Color dark = const Color(0xff705d2f);
  static Color light = const Color(0xffd2ba86);

//metthod

  BoxDecoration simplebox() => BoxDecoration(
        color: light,
      );
  BoxDecoration gradianBox() => BoxDecoration(
        gradient: RadialGradient(
          radius: 1.0,
          colors: [Colors.white, light],
        ),
      );

  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.dark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );

  TextStyle h1Style() => TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold, //ตัวหนา
        color: dark,
      );
  TextStyle h2Style() => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700, //หัวข้อ
        color: dark,
      );
  TextStyle h3Style() => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal, //ตัวปกติ
        color: dark,
      );
}
