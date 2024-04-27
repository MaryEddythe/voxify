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
          style: GoogleFonts.lexend(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, // Center the title
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: 200, // Adjust the height as needed
              child: Image.asset(
                'assets/wallpaper.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7), // Adjust opacity as needed
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Quippy!',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Quippy is a sleek and intuitive messaging app designed to streamline your conversations. Stay connected with friends, family, and colleagues through instant messaging. With Quippy, communication has never been easier!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Designed for the modern communicator who values wit, brevity, and spontaneity, Quippy lets you express yourself with style and flair. Whether youu are sending a quick message to a friend, engaging in a lively group chat, or sharing your thoughts with the world, Quippy provides the perfect platform for every conversation',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
