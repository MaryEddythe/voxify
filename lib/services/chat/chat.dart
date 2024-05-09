// chat.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:verbalize/models/message.dart';

class ChatService {
  // Get instance of Firestore and Auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // Go through each individual user
        final user = doc.data();

        // Return user
        return user;
      }).toList();
    });
  }

  // Send message
  Future<void> sendMessage(
      String receiverID, String receiverEmail, String message) async {
    // Get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      receiverEmail: receiverEmail,
      message: message,
      timestamp: timestamp,
    );

    // Construct chat room id for two users to ensure uniqueness
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // Sort id so 2 people have the same chat room id
    String chatRoomID = ids.join('_');

    // Add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // Construct chatroom id for two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  void deleteMessage(String id) {}
}
