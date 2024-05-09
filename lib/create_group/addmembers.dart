import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/group_chat/groupchat_screen.dart';

class AddMembers extends StatefulWidget {
  final String groupName, groupId;
  final List membersList;
  const AddMembers({
    required this.groupId, 
    required this.groupName,
    required this.membersList,     
    Key? key}) : super(key: key);

  @override
  State<AddMembers> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembers> {

  List<Map<String, dynamic>> UserTile = []; // Define UserTile here

  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List membersList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    membersList = widget.membersList;
  }
  

  void onSearch(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('user')
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      setState(() {
        UserTile = List<Map<String, dynamic>>.from(querySnapshot.docs.map((doc) => doc.data()));
        _search.text = query;
      });
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void onAddMembers() async {

    membersList.add({
      "email": userMap!['email'],
      "uid": userMap!['uid'],
      "isAdmin": false,
    });

    await _firestore
    .collection('groups')
    .doc(widget.groupId)
    .update({
      "members": membersList,
    });

    await _firestore
    .collection('users')
    .doc(_auth.currentUser!.uid)
    .collection('groups')
    .doc(widget.groupId)
    .set({
      "name": widget.groupName,
      "id": widget.groupId,
    });

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => GroupChatHomeScreen()), 
      (route) => false);
  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Members",
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
           
            SizedBox(height: size.height / 20),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height / 50),
            isLoading
                ? Container(
              height: size.height / 10,
              width: size.height / 12,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
                : ElevatedButton(
              onPressed: () => onSearch(_search.text),
              child: Text("Search"),
            ),

            // Check if userMap is not null before accessing its properties
            if (userMap != null)
              ListTile(
                onTap: onAddMembers,
                leading: Icon(Icons.account_box),
                title: Text(userMap!['email'] ?? ''),
                trailing: Icon(Icons.add),
              ),
          ],
        ),
      ),
      
    );
  }
}
