import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatchit/ui/common/app_colors.dart';

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
            onPressed: () {},
            child: const Icon(
              Icons.add_comment_rounded,
              color: kcVeryLightGrey,
            )),
      ),
    );
  }
}
