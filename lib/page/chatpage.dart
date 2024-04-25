import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verbalize/backend/chat_bubble.dart';
import 'package:verbalize/backend/textfield.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/services/chat/chat.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          widget.receiverEmail,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Color.fromARGB(255, 69, 67, 67),
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        foregroundColor: Colors.grey,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
  String senderID = _authService.getCurrentUser()!.uid;
  return StreamBuilder(
    stream: _chatService.getMessages(widget.receiverID, senderID),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text("Error");
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Text("Loading...");
      }
      return ListView.builder(
        controller: _scrollController,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          return _buildMessageItem(snapshot.data!.docs[index], index, snapshot.data!.docs.length);
        },
      );
    },
  );
}

  Widget _buildMessageItem(DocumentSnapshot doc, int index, int totalCount) {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;
  var alignmet = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

  // Parse the timestamp from the data
  Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
  DateTime dateTime = timestamp.toDate();

  // Format the time based on the 12-hour clock format
  String timeString = DateFormat.jm().format(dateTime); 

  // Check if this is the last message
  bool isLastMessage = index == totalCount - 1;

  return Column(
    crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    children: [
      ChatBubble(message: data ["message"], isCurrentUser: isCurrentUser),
      if (isLastMessage) // Show time only for the last message
        Text(
          timeString,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
    ],
  );
}



  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xff5072A7),
              shape: BoxShape.circle
            ),
            margin: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: sendMessage, 
              icon: const Icon(
                Icons.arrow_upward, 
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
