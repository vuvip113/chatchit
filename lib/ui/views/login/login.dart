import 'package:flutter/material.dart';
import 'package:chatchit/ui/common/app_colors.dart';
import 'package:chatchit/ui/common/ui_helpers.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            right: mq.width * .25,
            width: mq.width * .5,
            duration: const Duration(seconds: 1),
            child: Image.asset('assets/img/chat.png')),
        Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .06,
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: orangeNormal, elevation: 1),
                onPressed: () {},
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
