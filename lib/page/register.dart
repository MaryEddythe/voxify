import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/backend/button.dart';
import 'package:verbalize/backend/textfield.dart';

class Register extends StatelessWidget {
    //email and pass controller//
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();

  //tap register//
  final void Function()? onTap;

   Register({super.key, required this.onTap})
   ;
   //register methid//
   void register(BuildContext context) async {
  // Get auth service
  final _auth = AuthService();

  // Check if passwords match
  if (_passwordController.text == _confirmpasswordController.text) {
    try {
      // Await the sign-up process
      await _auth.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      // If sign-up is successful, you can navigate to another screen or show a success message
    } catch (e) {
      // If an exception occurs during sign-up, show an error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  } else {
    // Show an error dialog if passwords don't match
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("Passwords don't match!"),
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
            Text("Welcome aboard! Get ready to chat, connect, and have fun!", 
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

             //confrim pass//
            const SizedBox(height: 10),
            MyTextField(
              hintText: "Confirm Password",
              obscureText: true,
              controller: _confirmpasswordController,
            ),

            //login//
            const SizedBox(height: 25),
            MyButton(
              text: "Create Account",
              onTap: () => register(context),
            ),

            //reg//
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text("Login",
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
