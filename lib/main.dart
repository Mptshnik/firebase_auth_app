import 'package:firebase_app/home.dart';
import 'package:firebase_app/index.dart';
import 'package:firebase_app/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'auth.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  
  // try{
  //   UserCredential user = await auth.createUserWithEmailAndPassword(email: 'test@mail.ru', password: 'Qwerty!@!121');

  // }
  // on FirebaseAuthException catch(e)
  // {
  //   if(e.code == 'weak-password')
  //   {
  //     print('Пароль слишком слабый');
  //   }
  // }
  // catch(e)
  // {
  //   print(e);
  // }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'firebaseApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'index',
      routes: {
        'index': (context) => IndexPage(),
        'auth': (context) => AuthPage(),
        'register': (context) => RegisterPage(),
        'home': (context) => HomePage(),
        
      },
    );
  }
}