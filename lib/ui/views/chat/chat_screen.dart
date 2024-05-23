import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatchit/repositories/api.dart';
import 'package:chatchit/models/chat_user.dart';
import 'package:chatchit/ui/common/app_colors.dart';
import 'package:chatchit/ui/common/ui_helpers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // flexibleSpace: _appBar(),
        title: _appBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: APIs.getAllMessages(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;
                      final list = [];
                      if (list.isNotEmpty) {
                        return ListView.builder(
                            padding: const EdgeInsets.only(top: 4),
                            physics: const BouncingScrollPhysics(),
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return Text("Message: ${list[index]}");
                            });
                      } else {
                        return const Center(
                          child: Text(
                            "Say Hi! 👋",
                            style:
                                TextStyle(fontSize: 20, color: kcDarkGreyColor),
                          ),
                        );
                      }
                  }
                }),
          ),
          _chatInput()
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: orangeLight)),
          ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .03),
            child: CachedNetworkImage(
              width: mq.height * .05,
              height: mq.height * .05,
              fit: BoxFit.cover,
              imageUrl: widget.user.image,
              errorWidget: (context, url, error) =>
                  const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //user name
              Text(widget.user.name,
                  style: const TextStyle(
                      fontSize: 17,
                      // color: Colors.black87,
                      fontWeight: FontWeight.w900)),

              //for adding some space
              const SizedBox(height: 2),

              //last seen time of user
              Text(widget.user.lastActive,
                  style: const TextStyle(
                    fontSize: 13,
                    // color: Colors.black54,
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * .03),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_emotions_outlined,
                        color: orangeNormal),
                  ),
                  Expanded(
                      child: TextField(
                    // controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {},
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.image_outlined, color: orangeNormal),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: orangeNormal),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {},
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: orangeNormal,
            child: const Icon(Icons.send, color: Colors.white),
          )
        ],
      ),
    );
  }
}
