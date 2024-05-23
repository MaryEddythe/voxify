import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String receiverEmail;
  final String message;
  final Timestamp timestamp;
  final bool seen; // Add seen field

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.receiverEmail,
    required this.message,
    required this.timestamp,
    this.seen = false, // Initialize seen to false
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'receiverEmail': receiverEmail,
      'message': message,
      'timestamp': timestamp,
      'seen': seen, // Add seen to map
    };
  }
}
