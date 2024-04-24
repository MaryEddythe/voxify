import 'package:flutter/material.dart';
import 'package:verbalize/page/login.dart';
import 'package:verbalize/page/register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  //show anay login//
  bool showLoginPage = true;

  //toggle login/reg //
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return Login(
        onTap: togglePages,
      );
    } else{
      return Register(
        onTap: togglePages,
      );
    }
  }
}