import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService{
  //instance auth and firestore//
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user//
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in//
  Future<UserCredential> signInWithEmailPassword(String email, password) async{
    try {
      //sign user in//
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password, 
        );

        //save user info if it does not exist//
        _firestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid, 
            'email': email,
            
        },
        );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

   //signup//
  Future<UserCredential> signUpWithEmailAndPassword(String email, password) async{
    try{
      //create user//
      UserCredential userCredential = 
      await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password,
        );

        //save user info//
        _firestore.collection("Users").doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid, 
            'email': email,

        },
        );


        return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //logout methof//
  Future<void> signOut () async {
    return await _auth.signOut();
  }

}