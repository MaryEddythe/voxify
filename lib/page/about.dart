import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 69, 67, 67),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      
    );
  }
}
