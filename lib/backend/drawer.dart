import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/page/about.dart';
import 'package:verbalize/page/dev.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/page/settings.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // ignore: unused_field
  bool _isHovered = false;

  void logout() {
    // Get auth service
    final _auth = AuthService();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              // Logo
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.primary,
                    size: 40,
                  ),
                ),
              ),

              // List tiles
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: ListTile(
                  title: Text(
                    "HOME",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  leading: const Icon(Icons.home),
                  onTap: () {
                    // Pop drawer
                    Navigator.pop(context);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: ListTile(
                    title: Text(
                      "THEMES",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      // Pop drawer
                      Navigator.pop(context);

                      // Go to settings page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: ListTile(
                    title: Text(
                      "ABOUT US",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      // Pop drawer
                      Navigator.pop(context);

                      // Go to about page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AboutPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: ListTile(
                    title: Text(
                      "DEVELOPERS",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    leading: const Icon(Icons.settings),
                    onTap: () {
                      // Pop drawer
                      Navigator.pop(context);

                      // Go to about page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Developers(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),

          // Logout ListTile
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 25.0),
            child: ListTile(
              title: Text(
                "LOGOUT",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
