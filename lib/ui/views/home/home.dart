import 'package:flutter/material.dart';
import 'package:chatchit/repositories/api.dart';
import 'package:chatchit/ui/common/app_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatchit/ui/common/widgets/chat_user_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Chat Chit"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
        ],
      ),

      //floating button to add new user
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
            backgroundColor: orangeNormal,
            onPressed: () async {
              await APIs.auth.signOut();
              await GoogleSignIn().signOut();
            },
            child: const Icon(
              Icons.add_comment_rounded,
              color: kcVeryLightGrey,
            )),
      ),

      body: ListView.builder(
          padding: const EdgeInsets.only(top: 4),
          physics: const BouncingScrollPhysics(),
          itemCount: 16,
          itemBuilder: (context, index) {
            return const ChatUserCard();
          }),
    );
  }
}
