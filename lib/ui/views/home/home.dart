import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatchit/models/chat_user.dart';
import 'package:chatchit/repositories/api.dart';
import 'package:chatchit/ui/common/app_colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chatchit/ui/views/profile/profile_screen.dart';
import 'package:chatchit/ui/common/widgets/chat_user_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name, Email, ...',
                    ),
                    autofocus: true,
                    style: const TextStyle(
                      fontSize: 17,
                      letterSpacing: 0.5,
                    ),
                    onChanged: (val) {
                      _searchList.clear();
                      for (var i in _list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) &&
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : const Text("Chat Chit"),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: APIs.me)));
                  },
                  icon: const Icon(Icons.more_vert))
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

          body: StreamBuilder(
              stream: APIs.getALlUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final data = snapshot.data?.docs;
                      _list = data
                              ?.map((e) => ChatUser.fromJson(e.data()))
                              .toList() ??
                          [];
                    }
                    if (_list.isNotEmpty) {
                      return ListView.builder(
                          padding: const EdgeInsets.only(top: 4),
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              _isSearching ? _searchList.length : _list.length,
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                                user: _isSearching
                                    ? _searchList[index]
                                    : _list[index]);
                          });
                    } else {
                      return const Center(
                        child: Text(
                          "Khong co du lieu",
                          style:
                              TextStyle(fontSize: 20, color: kcDarkGreyColor),
                        ),
                      );
                    }
                }
              }),
        ),
      ),
    );
  }
}
