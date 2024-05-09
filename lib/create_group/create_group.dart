import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:verbalize/group_chat/groupchat_screen.dart';// Import GroupChatHomeScreen

class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> userTile;

  const CreateGroup({Key? key, required this.userTile}) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void createGroup() async {
    setState(() {
      isLoading = true;
    });

    try {
      String groupId = Uuid().v4(); // Generate a version 4 UUID

      await _firestore.collection('groups').doc(groupId).set({
        "members": widget.userTile,
        "id": groupId,
        "name": _groupName.text, // Save the group name
      });

      // Loop through the users and add the group to their collection
      for (int i = 0; i < widget.userTile.length; i++) {
        String uid = widget.userTile[i]['uid'];
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('groups')
            .doc(groupId)
            .set({
          "name": _groupName.text, // Save the group name
          "id": groupId,
        });
      }

      // Add a chat message to the group to notify users
      await _firestore.collection('groups').doc(groupId).collection('chats').add({
        "message": "${_auth.currentUser!.displayName} created this group",
        "type": "notify",
        "timestamp": FieldValue.serverTimestamp(), // Add timestamp
      });

      // Navigate back to GroupChatHomeScreen
      Navigator.of(context).pop();
    } catch (e) {
      print("Error creating group: $e");
      // Show error message or handle error as needed
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Group Name",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(height: size.height / 10),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    width: size.width / 1.15,
                    child: TextField(
                      controller: _groupName,
                      decoration: InputDecoration(
                        hintText: "Enter Group Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height / 50),
                ElevatedButton(
                  onPressed: createGroup,
                  child: Text("Create Group"),
                )
              ],
            ),
    );
  }
}
