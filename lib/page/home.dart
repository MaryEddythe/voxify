import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/backend/drawer.dart';
import 'package:verbalize/backend/usertile.dart';
import 'package:verbalize/page/chatpage.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/services/chat/chat.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key});

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
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5), // Set border radius here
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 16), // Adjust only the left padding here
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Implement search functionality here
                    },
                    icon: Icon(Icons.search),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          SizedBox (height: 20),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
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
    } else {
      return Container();
    }
  }
}
