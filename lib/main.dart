import 'package:appnote/Home/homepage.dart';
import 'package:appnote/auth/login.dart';
import 'package:appnote/auth/signup.dart';
import 'package:appnote/crud/addnotes.dart';
import 'package:appnote/crud/editnotes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

bool? islogin;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    islogin = false;
  } else {
    islogin = true;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: "Kalam",
        // hintColor: Colors.purple,
        primaryColor: Colors.purple,
        buttonColor: Colors.purple,
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 20, color: Colors.white),
          headline4: TextStyle(fontSize: 19, color: Colors.white),
          headline5: TextStyle(fontSize: 30, color: Colors.purple),
          bodyText2: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      home: islogin == false ? Login() : Homepage(),
      routes: {
        "login": (context) => Login(),
        "signup": (context) => SignUp(),
        "homepage": (context) => Homepage(),
        "addnotes": (context) => AddNotes(),
        "editnotes": (context) => EditNotes()
      },
    );
  }
}
 
