import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/group_chat/groupinfo.dart';

class GroupChatRoom extends StatefulWidget {
  final String groupChatId, groupName;

  const GroupChatRoom({
    required this.groupChatId,
    required this.groupName,
    Key? key,
  }) : super(key: key);

  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
  final FocusNode myFocusNode = FocusNode();

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
      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats')
          .add({
        "sendBy": _auth.currentUser!.displayName,
        "message": _messageController.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      });
      _messageController.clear();
      scrollDown();
    }
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          widget.groupName,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => GroupInfo(
                  groupName: widget.groupName,
                  groupId: widget.groupChatId,
                ),
              ),
            ),
            icon: Icon(Icons.more_vert),
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.27,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groups')
                    .doc(widget.groupChatId)
                    .collection('chats')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> chatMap =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        return messageTile(size, chatMap);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            _buildUserInput(),
          ],
        ),
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
                TextField(
                  controller: _messageController,
                  focusNode: myFocusNode,
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Positioned(
                  right: 40,
                  bottom: 7,
                  child: FloatingActionButton(
                    onPressed: sendMessage,
                    child: Icon(Icons.send),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: EdgeInsets.symmetric(
            horizontal: size.width / 100,
            vertical: size.height / 400,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.green.shade500,
            ),
            child: Column(
              children: [
                Text(
                  chatMap['sendBy'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 56, 41, 168),
                  ),
                ),
                SizedBox(height: size.height / 200),
                Text(
                  chatMap['message'],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return SizedBox();
      }
    });
  }
}

