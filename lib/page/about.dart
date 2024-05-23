import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State
{
  late bool _fadeIn = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 700), () {
      setState(() {
        _fadeIn = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "About Us",
          style: GoogleFonts.lexend(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, 
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: 200, 
              child: Image.asset(
                'assets/wallpaper.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7), 
            ),
          ),
          AnimatedOpacity(
            duration: Duration(milliseconds: 700),
            opacity: _fadeIn ? 1.0 : 0.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 1), 
                Text(
                  'Welcome to Quippy!',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 30), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Quippy is a sleek and intuitive messaging app designed to streamline your conversations. Stay connected with friends, family, and colleagues through instant messaging. With Quippy, communication has never been easier!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                SizedBox(height: 20), 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Designed for the modern communicator who values wit, brevity, and spontaneity, Quippy lets you express yourself with style and flair. Whether you are sending a quick message to a friend, engaging in a lively group chat, or sharing your thoughts with the world, Quippy provides the perfect platform for every conversation',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
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
