import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:groupe10/screens/signin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          backgroundColor: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        // Attend la fin de l'initialisation de Firebase
        future: Firebase.initializeApp(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Affiche un écran de chargement pendant l'initialisation
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              ),
            );
          } else {
            // Navigue vers l'écran de connexion une fois l'initialisation terminée
            return SignInScreen();
          }
        },
      ),
    );
  }
}
