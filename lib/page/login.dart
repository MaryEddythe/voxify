import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/backend/button.dart';
import 'package:verbalize/backend/textfield.dart';

class Login extends StatelessWidget {
  // email and pass controller//
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // tap register//
  final void Function()? onTap;

  Login({Key? key, required this.onTap});

  // login method//
  void login(BuildContext context) async {
    // get auth serv//
    final authService = AuthService();

    // try u login
    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
    }
    // if may error
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/wala.jpg"), 
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo image//
                Image.asset(
                  "assets/logo.png", // Change to your logo image path
                  width: 150, // Adjust the width as needed
                  height: 150, // Adjust the height as needed
                ),

                // welcome message//
                const SizedBox(height: 20), // Adjusted size for spacing
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Welcome to Quippy!",
                        style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      //SizedBox(height: 5), // Added space between texts
                      Text(
                        "Dive in, connect, and let the conversations begin!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // email//
                const SizedBox(height: 20),
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController,
                ),

                // pass//
                const SizedBox(height: 10),
                MyTextField(
                  hintText: "Password",
                  obscureText: true,
                  controller: _passwordController,
                ),

                // login//
                const SizedBox(height: 25),
                MyButton(
                  text: "Login",
                  onTap: () => login(context),
                ),

                // reg//
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: GoogleFonts.lexend(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        "Register Now!",
                        style: GoogleFonts.lexend(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
