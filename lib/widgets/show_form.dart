import 'package:flutter/material.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class ShowForm extends StatelessWidget {
  final String title;
  final String? Function(String?) myValidate;
  final Function(String?) mySave;
  final TextEditingController? textEditingController;
  const ShowForm({
    Key? key,
    required this.title,
    required this.myValidate,
    required this.mySave,
    this.textEditingController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(controller: textEditingController ?? TextEditingController(),
        onSaved: mySave,
        validator: myValidate,
        decoration: InputDecoration(
          label: ShowText(title: title),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
