import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Developers extends StatelessWidget {
  const Developers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.inversePrimary;
    final Color textColor = Colors.black; 

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Developers",
          style: GoogleFonts.lexend(
            textStyle: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 5, 54, 94),
                            width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: 170,
                        height: 170,
                        margin: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/edith.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Mary Eddythe M. Sornito',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5), 
                    Text(
                      'BSIT-3B',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 15), 
                Column(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 5, 54, 94),
                            width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        width: 170,
                        height: 170,
                        margin: const EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/dev3.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kyle G. Velez',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5), 
                    Text(
                      'BSIT-3B',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'About the Project',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Container(
                        width: constraints.maxWidth,
                        height: 5, 
                        color: Colors.blue, 
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20), 
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'The developers, Mary Eddythe Sornito and Kyle Velez in their third year of Bachelor of Science in Information Technology (BSIT) at West Visayas State University have dedicated themselves to specializing in Software Technologies. This particular application represents the culmination of their efforts, serving as the final project for their Mobile Application Development course.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'The application uses Flutter, a versatile framework for building dynamic and visually appealing mobile applications. The students utilize Visual Studio Code as their Integrated Development Environment (IDE), a robust tool providing a seamless coding experience and powerful features for efficient development. Firebase, a comprehensive platform offered by Google, is integrated into the application. Firebase enhances the app\'s functionality by providing essential services such as real-time database management, authentication, and cloud storage, thereby enriching the overall user experience and ensuring seamless performance.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'This application is strictly developed for educational purposes. The developers want to emphasize that they do not claim ownership of any images, icons, or graphics utilized within the application. These visual elements are sourced responsibly from open-access or royalty-free platforms, ensuring compliance with copyright regulations and ethical standards. It is a testament to the developers\' commitment to integrity and respect for intellectual property rights while honing their skills and knowledge in software development.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
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
