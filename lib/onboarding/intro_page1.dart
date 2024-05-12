import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this line

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDFDFD), 
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              Text(
                'Welcome to Quippy, where conversations come alive!',
                style: GoogleFonts.lexend(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, 
                ),
                textAlign: TextAlign.center, 
              ),
              SizedBox(height: 20), 
              Image.asset(
                'assets/gif.gif', 
                width: 500, 
                height: 500, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
