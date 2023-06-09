import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupe10/screens/home_screen.dart';
import 'package:groupe10/screens/reset_password.dart';
import 'package:groupe10/screens/signup_screen.dart';
import 'package:groupe10/services/firebase_services.dart';
import 'package:groupe10/utils/color_utils.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("007FFF"),
            hexStringToColor("007FFF"),
            hexStringToColor("007FFF")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/6404259.png"),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Entrez votre mail", Icons.person_outline,
                    false, _emailTextController),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Entrez votre mot de passe",
                    Icons.lock_outline, true, _passwordTextController),
                const SizedBox(
                  height: 8,
                ),
                forgetPassword(context),
                firebaseButton(context, "Se connecter", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen(isGoogleSignIn: false)));
                    _emailTextController.text =""; 
                    _passwordTextController.text = "";
                  }).onError((error, stackTrace) {
                    setState(() {
                      if (error.toString() == "[firebase_auth/unknown] Given String is empty or null"){
                        errorMessage = "Veuillez remplire tous les champs";
                      }
                      if (error.toString() == "[firebase_auth/wrong-password] The password is invalid or the user does not have a password."){
                        errorMessage = "Email ou mot de passe incorrect !";
                      }
                      
                    });
                    _showErrorDialog();
                  });
                  _emailTextController.text =""; 
                  _passwordTextController.text = "";
                }),
                signInOption(),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("vous n'avez pas de compte?",
            style: TextStyle(color: Colors.white70)),
        SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            "Inscrivez-vous",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Se connecter avec ? ",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () async {
            await FirebaseServices().signInWithGoogle();
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(isGoogleSignIn: true)));
          },
          child: Row(
            children: [
              const SizedBox(width: 5),
              const Text(
                "Google",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 2),
              FaIcon(FontAwesomeIcons.google, color: Colors.white, size: 10),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            // Ajoutez ici le code pour se connecter avec Facebook
          },
          child: Row(
            children: [
              const SizedBox(width: 7),
              const Text(
                "Facebook",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 2),
              FaIcon(FontAwesomeIcons.facebook, color: Colors.white, size: 10),
            ],
          ),
        ),
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: Text(
          "Mot de passe oublié?",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }

  void _showErrorDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Erreur de connexion'),
        content: Text(errorMessage),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}
