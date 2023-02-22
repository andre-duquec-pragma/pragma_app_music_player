import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  static String name = "loginPage";
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('User not logged'),
      ),
    );
  }
}
