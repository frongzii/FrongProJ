import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';

class ContactCustomer extends StatefulWidget {
  const ContactCustomer({Key? key}) : super(key: key);

  @override
  _ContactCustomerState createState() => _ContactCustomerState();
}

class _ContactCustomerState extends State<ContactCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyConstant.primart,
        title: Text('ติดต่อลูกค้า'),
      ),
    );
  }
}
