import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:verbalize/backend/chat_bubble.dart';
import 'package:verbalize/backend/textfield.dart';
import 'package:verbalize/services/auth/authservice.dart';
import 'package:verbalize/services/chat/chat.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;


   ChatPage({
    super.key, 
    required this.receiverEmail,
    required this.receiverID,
    }
  );

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //  text controller//
  final TextEditingController _messageController = TextEditingController();

  //chat and auth servicess//
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  //textfield focus node//
  FocusNode myFocusNode =  FocusNode();

  @override
  void initState() {
    super.initState();

    //add listener to focus on node//
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        //cause a delay so keyboard has time to show up//
        //space will be calculated then scroll down//

        Future.delayed(const Duration(milliseconds: 500), 
        () => scrollDown(),
        );
      }
    });

    //wait a bit for listview to be built, then scroll to bottom//
    Future.delayed(const Duration(milliseconds: 500), 
    () => scrollDown(),
    );
  }

  //send message//
  void sendMessage() async {
    //if there is something inside textfield//
    if(_messageController.text.isNotEmpty){
      //send the message//
      await _chatService.sendMessage(widget.receiverID, _messageController.text);

      //clear text controller//
      _messageController.clear();
    }

    scrollDown();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller//
  final ScrollController _scrollController = ScrollController();
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
      title: Text(widget.receiverEmail),
      foregroundColor: Colors.grey,
     backgroundColor: Colors.transparent, 
     elevation: 0,
      ),
      body: Column(
        children: [
          //display all messages//
          Expanded(child: _buildMessageList(),
          ),

          _buildUserInput(),
        ],
      ),
    );
  }

  //build message list//
  Widget _buildMessageList(){
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //errors//
        if(snapshot.hasError) {
          return const Text("Error");
        }

        //loading//
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        //retrun listview//
        return ListView(
          controller: _scrollController,
          children: 
          snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      }
    );
  }

  //build message item//
  Widget _buildMessageItem(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    //current user//
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    //align to right if sender is current user//
    var alignmet = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignmet,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end :CrossAxisAlignment.start,
        children: [
          ChatBubble(message: data ["message"], 
          isCurrentUser: isCurrentUser,
          )
        ],
      ));
  }

  //build message input//
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          //textfield should take up most of space//
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              focusNode: myFocusNode,
            ),
          ),
      
          //send button//
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