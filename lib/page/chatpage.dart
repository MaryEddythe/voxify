import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/backend/chat_bubble.dart';
import 'package:verbalize/backend/textfield.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/services/chat/chat.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    Key? key,
    required this.receiverEmail,
    required this.receiverID,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  FocusNode myFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  int lastClickedIndex = -1;
  late AppUser _currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _initializeCurrentUser() async {
    _currentUser = (await _authService.getCurrentUser())!;
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, widget.receiverEmail, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void handleChatBubbleClick(int index) {
    setState(() {
      if (lastClickedIndex == index) {
        lastClickedIndex = -1;
      } else {
        lastClickedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection("Users").doc(widget.receiverID).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text(
                widget.receiverEmail,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              );
            }
            if (snapshot.hasData && snapshot.data != null) {
              final userDoc = snapshot.data!;
              final status = userDoc['status'] ?? 'Offline';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.receiverEmail,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Color.fromARGB(255, 69, 67, 67),
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    status,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Text(
                widget.receiverEmail,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: Color.fromARGB(255, 69, 67, 67),
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              );
            }
          },
        ),
        foregroundColor: Colors.grey,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<void>(
        future: _initializeCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), 
            );
          }
          return Column(
            children: [
              Expanded(
                child: _buildMessageList(),
              ),
              _buildUserInput(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageList() {
    if (_currentUser == null) {
      return const SizedBox(); 
    }

    String senderID = _currentUser.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        return ListView.builder(
          controller: _scrollController,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(
                snapshot.data!.docs[index], index, snapshot.data!.docs.length);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc, int index, int totalCount) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _currentUser.uid;
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
    DateTime messageDateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    int differenceInDays = now.difference(messageDateTime).inDays;
    String timeString = DateFormat.jm().format(messageDateTime);
    if (differenceInDays > 1) {
      timeString = DateFormat('EEEE').format(messageDateTime);
    } else if (differenceInDays > 7) {
      timeString = DateFormat('MMM d').format(messageDateTime);
    }


    bool seen = data['seen'] ?? false; 
    if (!isCurrentUser && !seen) {
      String chatRoomID = ([widget.receiverID, _currentUser.uid]..sort()).join('_');
      _chatService.markMessageAsSeen(chatRoomID, doc.id);
    }

    return GestureDetector(
      onLongPress: () {
        _messageController.text = '${data["message"]} ';
        myFocusNode.requestFocus();
      },
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            transform: lastClickedIndex == index
                ? Matrix4.translationValues(0, -5, 0)
                : Matrix4.translationValues(0, 0, 0),
            child: ChatBubble(
                message: data["message"], isCurrentUser: isCurrentUser),
          ),
          if (index == totalCount - 1 || index == lastClickedIndex)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeString,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                if (isCurrentUser && seen)
                  Text(
                    ' Seen',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 50.0, left: 15, right: 0),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                MyTextField(
                  controller: _messageController,
                  hintText: "Type a message",
                  obscureText: false,
                  focusNode: myFocusNode,
                ),
                Positioned(
                  right: 40,
                  bottom: 7,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xff5072A7),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
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
