import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCFCFC), 
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your Quippy journey begins now!',
                style: GoogleFonts.montserrat(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'Get started and stay connected.',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Image.asset(
                'assets/sms.gif',
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