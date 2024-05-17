import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/backend/drawer.dart';
import 'package:verbalize/backend/usertile.dart';
import 'package:verbalize/page/chatpage.dart'; 
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/services/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  late AppUser _currentUser;
  late List<Map<String, dynamic>> _users;
  late List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _initializeCurrentUser();
    _initializeUsers();
  }

  void _initializeCurrentUser() async {
    _currentUser = (await _authService.getCurrentUser()) ?? AppUser(uid: '', email: '', avatarUrl: '');
  }

  void _initializeUsers() async {
    final AppUser? currentUser = await _authService.getCurrentUser();
    if (currentUser != null) {
      final currentUserUid = currentUser.uid;
      _chatService.getUsersStream().listen((users) {
        setState(() {
          _users = List.from(users);
          _filteredUsers = List.from(users);
        });
      });
    }
  }

  void _searchUser(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = List.from(_users);
      } else {
        _filteredUsers =
            _users.where((user) => user["email"].contains(query)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "Chats",
          style: GoogleFonts.poppins().copyWith(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.w900,
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
                  Container(
                    width: 50,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Icon(Icons.search, color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  Expanded(
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: TextField(
                        onChanged: _searchUser,
                        style: GoogleFonts.poppins(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search",
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: _buildUserList()),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      itemCount: _filteredUsers.length,
      itemBuilder: (context, index) {
        return _buildUserListItem(_filteredUsers[index], context);
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _currentUser.email) {
      return StreamBuilder(
        stream: _chatService.getMessages(
            _currentUser.uid, userData["uid"]),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final lastMessage = snapshot.data!.docs.isNotEmpty
                  ? snapshot.data!.docs.last['message']
                  : '';
              final lastSenderEmail = snapshot.data!.docs.isNotEmpty
                  ? snapshot.data!.docs.last['senderEmail']
                  : '';
              final combinedMessage = lastMessage.isNotEmpty
                  ? 'Last message: $lastMessage'
                  : '';
              return Dismissible(
                key: Key(userData["uid"]),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
                onDismissed: (direction) {
                  setState(() {
                    _filteredUsers.remove(userData);
                  });
                },
                child: UserTile(
                  text: userData["email"],
                  lastMessage: combinedMessage,
                  sender: lastSenderEmail,
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
                ),
              );
            }
          }
        },
      );
    } else {
      return Container();
    }
  }
}
