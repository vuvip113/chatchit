import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chatchit/helper/dialog.dart';
import 'package:chatchit/repositories/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatchit/ui/views/home/home.dart';
import 'package:chatchit/ui/common/app_colors.dart';
import 'package:chatchit/ui/common/ui_helpers.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(microseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  // handles google login button click
  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then(
      (user) async {
        Navigator.pop(context);
        if (user != null) {
          if (await APIs.userExists() && mounted) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const Home()));
          } else {
            APIs.createUser().then((value) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const Home()));
            });
          }
        }
      },
    ).catchError((error) {
      print('Error signing in with Google: $error');
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup("google.com");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Error signing in with Google: $e');
      Dialogs.showSnackbar(context, "Something went WRONG");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Welcome '),
      ),
      body: Stack(children: [
        AnimatedPositioned(
            top: mq.height * .15,
            right: _isAnimate ? mq.width * .25 : -mq.width * .5,
            width: mq.width * .5,
            duration: const Duration(milliseconds: 500),
            child: Image.asset('assets/img/chat.png')),
        Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: orangeNormal, elevation: 1),
                onPressed: () {
                  _handleGoogleBtnClick();
                },
                icon: Image.asset('assets/img/google.png',
                    height: mq.height * .04),
                label: RichText(
                  text: const TextSpan(
                      style: TextStyle(color: kcVeryLightGrey, fontSize: 16),
                      children: [
                        TextSpan(text: 'Login with '),
                        TextSpan(
                            text: 'Google',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ]),
                ))),
      ]),
    );
  }
}
