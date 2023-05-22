import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe10/screens/signin_screen.dart';
import 'package:groupe10/services/firebase_services.dart';

class HomeScreen extends StatefulWidget {
  final bool isGoogleSignIn;

  const HomeScreen({Key? key, required this.isGoogleSignIn}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    String buttonText = widget.isGoogleSignIn ? "Se déconnecter Google" : "Se déconnecter E-mail";

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text(buttonText),
          onPressed: () async {
            if (widget.isGoogleSignIn) {
              await FirebaseServices().signOut();
            } else {
              await FirebaseAuth.instance.signOut();
            }
            print("Déconnecté");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignInScreen()),
            );
          },
        ),
      ),
    );
  }
}
