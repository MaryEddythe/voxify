import 'package:flutter/material.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/backend/button.dart';
import 'package:verbalize/backend/textfield.dart';

class Login extends StatelessWidget {
  //email and pass controller//
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //tap register//
  final void Function()? onTap;

   Login({super.key,  required this.onTap});

   //login methid//
   void login(BuildContext context) async {

    //get auth serv//
    final authService = AuthService();

    //try u login
    try {
      await authService.signInWithEmailPassword(
        _emailController.text, 
        _passwordController.text,
        );
    }

    //if may error
    catch (e) {
      showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ),
      );
    }

   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo message//
            Icon(Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
            ),

            //welcome message//
            const SizedBox(height: 50,),
            Text("Welcome to Voxify! Dive in, connect, and let the conversations begin!", 
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
            ),

            //email//
            const SizedBox(height: 20),
            MyTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            //pass//
            const SizedBox(height: 10),
            MyTextField(
              hintText: "Password",
              obscureText: true,
              controller: _passwordController,
            ),

            //login//
            const SizedBox(height: 25),
            MyButton(
              text: "Login",
              onTap: () => login(context),
            ),

            //reg//
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text("Register Now!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
