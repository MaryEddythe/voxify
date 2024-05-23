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
  bool _isHovered = false;
  String? _currentUserEmail;
  String? _userAvatarUrl = 'assets/icons.png'; 

  @override
  void initState() {
    super.initState();
    _getCurrentUserData();
  }

  void _getCurrentUserData() async {
    final authService = AuthService();
    final currentUser = await authService.getCurrentUser();
    setState(() {
      _currentUserEmail = currentUser?.email;
      _userAvatarUrl = currentUser?.avatarUrl ?? _userAvatarUrl; 
    });
  }

  void logout() {
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
          Padding(
            padding: const EdgeInsets.only(top: 40.0), 
            child: Column(
              children: [
                // Custom Drawer Header
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        backgroundImage: AssetImage(_userAvatarUrl!), 
                      ),
                      SizedBox(height: 10),
                      Text(
                        _currentUserEmail ?? 'Loading...',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                      SizedBox(height: 8), 
                      Divider(), 
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: ListTile(
                    title: Text(
                      "HOME",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                    leading: Icon(Icons.home),
                    onTap: () {
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
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                      leading: Icon(Icons.settings),
                      onTap: () {
                        Navigator.pop(context);
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
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                      leading: Icon(Icons.info),
                      onTap: () {
                        Navigator.pop(context);
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
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ),
                      leading: Icon(Icons.developer_mode),
                      onTap: () {
                        Navigator.pop(context);
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 25.0),
            child: ListTile(
              title: Text(
                "LOGOUT",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
              leading: Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
