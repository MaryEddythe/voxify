import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/backend/button.dart';
import 'package:verbalize/backend/textfield.dart';

class Login extends StatefulWidget {
  final void Function()? onTap;

  Login({Key? key, required this.onTap}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true; // Track password visibility

  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void login(BuildContext context) async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
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
                Image.asset(
                  "assets/logo.png",
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                MyTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: _emailController,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hintText: "Password",
                  obscureText: _isObscure,
                  controller: _passwordController,
                  suffix: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: "Login",
                  onTap: () => login(context),
                ),
                const SizedBox(height: 20), // Add space between the Login button and the text
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: Divider(
                //         color: Theme.of(context).colorScheme.primary,
                //       ),
                //     ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //         child: Text(
              //           "OR CONTINUE WITH",
              //           style: GoogleFonts.lexend(
              //             textStyle: TextStyle(
              //               color: Theme.of(context).colorScheme.primary,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: Divider(
              //           color: Theme.of(context).colorScheme.primary,
              //         ),
              //       ),
              //     ],
              //   ),
              //   const SizedBox(height: 10), // Add space between Register link and new button
              //   ElevatedButton(
              //     onPressed: () {
              //       // Add functionality for the new button here
              //     },
              //     child: Text("Continue with Google"),
              // ),
              //SizedBox(height: 20,),
              //const FacebookAuthentication(),
                const SizedBox(height: 17), // Add space between the text and the Register link
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
                      onTap: widget.onTap,
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
          )
        )
        )
          );
  }
}
