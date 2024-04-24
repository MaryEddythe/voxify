import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:verbalize/services/auth/authgate.dart';
import 'package:verbalize/firebase_options.dart';
import 'package:verbalize/themes/light.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightMode,
    );
  }
}