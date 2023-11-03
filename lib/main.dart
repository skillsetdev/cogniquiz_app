import 'package:flashcards/cardsdata.dart';
import 'package:flashcards/check_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => FoldersData(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CogniQuiz",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: CheckAuth(),
    );
  }
}
