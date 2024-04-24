import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:verbalize/services/auth/loginorreg.dart';
import 'package:verbalize/page/home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){

          //user login
          if (snapshot.hasData){
            return HomePage();
          }

          //user not login
          else {
            return const LoginOrRegister();
          }
        }
      ),
    );
  }
}