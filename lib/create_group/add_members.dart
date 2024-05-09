import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verbalize/create_group/create_group.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({Key? key}) : super(key: key);

  @override
  _AddMembersInGroupState createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final TextEditingController _search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> userTile = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  void getCurrentUserDetails() async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      String currentUserEmail = currentUser.email!;
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .where('email', isEqualTo: currentUserEmail)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          userTile.add({
            "email": querySnapshot.docs.first['email'],
            "uid": querySnapshot.docs.first['uid'],
            "isAdmin": true,
          });
        });
      }
    }
  }

  void onSearch(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      print('Performing search query for: $query');
      QuerySnapshot querySnapshot = await _firestore
          .collection('Users')
          .where('email', isGreaterThanOrEqualTo: query)
          .where('email', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      print('Search query returned ${querySnapshot.docs.length} results');

      setState(() {
        userTile = List<Map<String, dynamic>>.from(querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>));
        _search.text = query;
      });
    } catch (e) {
      print("Error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void onResultTap(int index) {
    setState(() {
      userMap = userTile[index];
    });
  }

  void onPressed() {
    // Check if a user is selected
    if (userMap != null) {
      // Check if the selected user is already in the list
      bool alreadyAdded = userTile.any((user) => user['email'] == userMap!['email']);
      if (!alreadyAdded) {
        // Add the selected user to the list
        setState(() {
          userTile.add(userMap!);
          // Clear the selected user
          userMap = null;
        });
      }
    }
  }

  void onRemoveMembers(int index) {
    if (userTile[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        userTile.removeAt(index);
      });
    }
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
            Flexible(
              child: ListView.builder(
                itemCount: userTile.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => onResultTap(index),
                    leading: Icon(Icons.account_circle),
                    title: Text(userTile[index]['email'] ?? ''),
                    trailing: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => onPressed(),
                    ),
                  );
                },
              ),
            ),
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
            if (userMap != null)
              ListTile(
                onTap: () => onResultTap(userTile.indexOf(userMap!)),
                leading: Icon(Icons.account_box),
                title: Text(userMap!['email'] ?? ''),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => onPressed(),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: userTile.length >= 2
          ? FloatingActionButton(
              child: Icon(Icons.forward),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateGroup(userTile: userTile),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
