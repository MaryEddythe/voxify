import 'package:flutter/material.dart';
import 'package:verbalize/backend/drawer.dart';
import 'package:verbalize/backend/usertile.dart';
import 'package:verbalize/page/chatpage.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/services/chat/chat.dart';


class HomePage extends StatelessWidget {
   HomePage({super.key});

  //display users auth serivces//
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("Home"),
      foregroundColor: Colors.grey,
     backgroundColor: Colors.transparent, 
     elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  //build list of users//
  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUsersStream(),
      builder: (context, snapshot) {
        //error//

        if (snapshot.hasError){
          return const Text("Error");
        }

        //loading//
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        //return list view//
        return ListView(
          children: snapshot.data!.map<Widget>((userData) => _buildUserListItem(userData, context))
          .toList(),
        );
      }
    );
  }

  //build indiv list user tile//
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context)
  {
    //display all users exceot current//
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
      text: userData["email"],
      onTap: () {
        //tapped user//
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