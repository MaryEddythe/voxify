import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/backend/drawer.dart';
import 'package:verbalize/backend/notifservices.dart';
import 'package:verbalize/backend/usertile.dart';
import 'package:verbalize/page/chatpage.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/services/chat/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  late AppUser _currentUser;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    _initializeCurrentUser();
    _initializeUsers();
    notificationServices.requestNotificationPermission();
  }

  void setStatus(String status) async {
    if (_authService.currentUser != null) {
      await _firestore.collection('Users').doc(_authService.currentUser!.uid).update({
        "status": status,
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  Future<void> _initializeCurrentUser() async {
    _currentUser = (await _authService.getCurrentUser()) ?? AppUser(uid: '', email: '', avatarUrl: '');
    setState(() {});
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
          const SizedBox(height: 20),
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

  Widget _buildUserListItem(Map<String, dynamic>? userData, BuildContext context) {
    if (userData?["email"] != _currentUser.email) {
      return StreamBuilder(
        stream: _chatService.getMessages(_currentUser.uid, userData?["uid"]),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<DocumentSnapshot> docs = snapshot.data?.docs ?? [];
            final lastMessage = docs.isNotEmpty ? docs.last['message'] ?? '' : '';
            final lastSenderEmail = docs.isNotEmpty ? docs.last['senderEmail'] ?? '' : '';
            final timestamp = docs.isNotEmpty ? docs.last['timestamp'] as Timestamp? : null;
            final time = timestamp != null ? DateFormat('hh:mm a').format(timestamp.toDate()) : '';
            final unseenCount = docs.where((doc) => doc.data() != null && (doc.data() as Map<String, dynamic>).containsKey('seen') && !(doc.data() as Map<String, dynamic>)['seen'] && (doc.data() as Map<String, dynamic>)['senderID'] != _currentUser.uid).length;
            final isLastMessageUnseen = docs.isNotEmpty && docs.last.data() != null && (docs.last.data() as Map<String, dynamic>).containsKey('seen') && !(docs.last.data() as Map<String, dynamic>)['seen'] && (docs.last.data() as Map<String, dynamic>)['senderID'] != _currentUser.uid;

            return Dismissible(
              key: Key(userData!["uid"].toString()),
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
                text: userData?["email"] ?? '',
                lastMessage: lastMessage,
                sender: lastSenderEmail,
                time: time,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        receiverEmail: userData?["email"] ?? '',
                        receiverID: userData?["uid"] ?? '',
                      ),
                    ),
                  );
                },
                unseenCount: unseenCount,
                isLastMessageUnseen: isLastMessageUnseen,
              ),
            );
          }
        },
      );
    } else {
      return Container();
    }
  }
}
