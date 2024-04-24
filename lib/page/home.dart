import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/backend/drawer.dart';
import 'package:verbalize/backend/usertile.dart';
import 'package:verbalize/page/chatpage.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/services/chat/chat.dart';


class HomePage extends StatelessWidget {
   HomePage({Key? key});

  // Display users auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Chats",
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        centerTitle: true, // Center the title horizontally
        backgroundColor: Colors.transparent, 
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  // Build list of users
  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        // Error handling
        if (snapshot.hasError){
          return const Text("Error");
        }

        // Loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // Return list view
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context))
          .toList(),
        );
      }
    );
  }

  // Build individual list user tile
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context)
  {
    // Display all users except current user
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          // Tapped user
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    }
    else {
      return Container();
    }
  }
}
