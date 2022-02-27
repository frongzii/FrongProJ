import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frongeasyshop/utility/my_constant.dart';
import 'package:frongeasyshop/widgets/show_logo.dart';
import 'package:frongeasyshop/widgets/show_text.dart';

class ShowSignOut extends StatefulWidget {
  const ShowSignOut({Key? key}) : super(key: key);

  @override
  _ShowSignOutState createState() => _ShowSignOutState();
}

class _ShowSignOutState extends State<ShowSignOut> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: ListTile(
              leading: ShowLogo(),
              title: ShowText(
                title: 'คุณต้องการออกจากระบบหรือไม่?',
                textStyle: MyConstant().h2Style(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.pushNamedAndRemoveUntil(
                          context, MyConstant.routAuthen, (route) => false));
                },
                child: const Text('Sign Out'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.exit_to_app),
    );
  }
}
