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
  int lastClickedIndex = -1;

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
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
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
        // If the clicked message is the same as the last clicked one, reset lastClickedIndex
        lastClickedIndex = -1;
      } else {
        // Otherwise, set lastClickedIndex to the clicked index
        lastClickedIndex = index;
      }
    });
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
            return _buildMessageItem(
                snapshot.data!.docs[index], index, snapshot.data!.docs.length);
          },
        );
      },
    );
  }

  // Inside _buildMessageItem method
  Widget _buildMessageItem(DocumentSnapshot doc, int index, int totalCount) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // Parse the timestamp from the data
    Timestamp timestamp = data['timestamp'] ?? Timestamp.now();
    DateTime messageDateTime = timestamp.toDate();

    // Get the current time
    DateTime now = DateTime.now();

    // Calculate the difference in days
    int differenceInDays = now.difference(messageDateTime).inDays;

    // Format the time based on the 12-hour clock format
    String timeString = DateFormat.jm().format(messageDateTime);

    // Check if this is the last message or if it matches the last clicked index
    bool shouldShowTime = index == totalCount - 1 || index == lastClickedIndex;

    // Check if the message was sent more than 24 hours ago
    if (differenceInDays > 1) {
      // Show the day of the week if the message was sent more than 24 hours ago
      timeString = DateFormat('EEEE').format(messageDateTime);
    } else if (differenceInDays > 7) {
      // Show the month and date if the message was sent more than 7 days ago
      timeString = DateFormat('MMM d').format(messageDateTime);
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
            duration: Duration(milliseconds: 500),
            transform: lastClickedIndex == index
                ? Matrix4.translationValues(0, -5, 0)
                : Matrix4.translationValues(0, 0, 0),
            child: ChatBubble(
                message: data["message"], isCurrentUser: isCurrentUser),
          ),
          if (shouldShowTime)
            Text(
              timeString,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
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
          IconButton(
            onPressed: () {
              // Add your logic to handle emoji button press
            },
            icon: const Icon(
              Icons.image, // Use any emoji icon you prefer
              color: Color(0xff5072A7),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                MyTextField(
                  controller: _messageController,
                  hintText: "Type a message",
                  obscureText: false,
                  focusNode: myFocusNode,
                  suffix: IconButton(
                    onPressed: () {}, // Placeholder onPressed function
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                Positioned(
                  right: 40, // Adjust this value as needed to move the button more to the left
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
