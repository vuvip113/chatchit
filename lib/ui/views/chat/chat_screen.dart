import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatchit/models/message.dart';
import 'package:chatchit/repositories/api.dart';
import 'package:chatchit/models/chat_user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatchit/ui/common/app_colors.dart';
import 'package:chatchit/ui/common/ui_helpers.dart';
import 'package:chatchit/ui/common/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> list = [];
  final TextEditingController textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_showEmoji) {
            setState(() {
              _showEmoji = !_showEmoji;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            // flexibleSpace: _appBar(),
            title: _appBar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
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
                          list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                padding: const EdgeInsets.only(top: 4),
                                physics: const BouncingScrollPhysics(),
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: list[index],
                                  );
                                });
                          } else {
                            return const Center(
                              child: Text(
                                "Say Hi! 👋",
                                style: TextStyle(
                                    fontSize: 20, color: kcDarkGreyColor),
                              ),
                            );
                          }
                      }
                    }),
              ),
              if (_isUploading)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              _chatInput(),
              if (_showEmoji)
                SizedBox(
                  height: mq.height * .35,
                  child: EmojiPicker(
                    textEditingController: textController,
                    config: const Config(),
                  ),
                )
            ],
          ),
        ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(Icons.emoji_emotions_outlined,
                        color: orangeNormal),
                  ),
                  Expanded(
                      child: TextField(
                    controller: textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) {
                        setState(() {
                          setState(() => _showEmoji = !_showEmoji);
                        });
                      }
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final List<XFile> images =
                          await picker.pickMultiImage(imageQuality: 70);

                      for (var i in images) {
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(Icons.image_outlined, color: orangeNormal),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(Icons.camera_alt_outlined,
                        color: orangeNormal),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, textController.text, Type.text);
                textController.text = '';
              }
            },
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
