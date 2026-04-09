import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// entry point of the app
void main() async {
  // ensures flutter is initialized before firebase
  WidgetsFlutterBinding.ensureInitialized();

  // initializes firebase using generated platform config
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

// root widget of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('firebase auth ready'),
        ),
      ),
    );
  }
}