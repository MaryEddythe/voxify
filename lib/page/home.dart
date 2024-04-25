import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/backend/drawer.dart';
import 'package:verbalize/backend/usertile.dart';
import 'package:verbalize/page/chatpage.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/services/chat/chat.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  late List<Map<String, dynamic>> _users;
  late List<Map<String, dynamic>> _filteredUsers;

  @override
  void initState() {
    super.initState();
    _initializeUsers();
  }

  void _initializeUsers() {
    // Retrieve all users from the ChatService
    _chatService.getUsersStream().listen((users) {
      setState(() {
        _users = List.from(users); // Store all users
        _filteredUsers = List.from(users); // Initialize filtered users with all users
      });
    });
  }

  void _searchUser(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, display all users
        _filteredUsers = List.from(_users);
      } else {
        // Filter users whose email contains the search query
        _filteredUsers = _users.where((user) => user["email"].contains(query)).toList();
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
                        onChanged: _searchUser, // Call _searchUser on text change
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
                      // No need for search functionality here
                    },
                    icon: Icon(Icons.search),
                    color: Colors.black,
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

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
  if (userData["email"] != _authService.getCurrentUser()!.email) {
    return Dismissible(
      key: Key(userData["uid"]), // Unique key for each user
      direction: DismissDirection.endToStart, // Allow swipe from right to left
      background: Container(
        alignment: Alignment.centerRight,
        color: Colors.red, // Background color when swiping
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      onDismissed: (direction) {
        // Implement your deletion logic here
        setState(() {
          // Remove the user from the list
          _filteredUsers.remove(userData);
        });
      },
      child: UserTile(
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
      ),
    );
  } else {
    return Container();
  }
}
}