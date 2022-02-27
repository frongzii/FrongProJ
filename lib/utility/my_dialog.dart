import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/widgets/show_logo.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class MyDialog {
  Future<void> normalDialog(
      BuildContext context, String title, String message) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ListTile(
          leading: const ShowLogo(),
          title: ShowText(
            title: title,
            textStyle: MyConstant().h2Style(),
          ),
          subtitle: ShowText(title: message),
        ),actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }
}
