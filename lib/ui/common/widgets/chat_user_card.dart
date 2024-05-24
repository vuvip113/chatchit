import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatchit/models/message.dart';
import 'package:chatchit/repositories/api.dart';
import 'package:chatchit/models/chat_user.dart';
import 'package:chatchit/helper/my_date_util.dart';
import 'package:chatchit/ui/common/app_colors.dart';
import 'package:chatchit/ui/common/ui_helpers.dart';
import 'package:chatchit/ui/views/chat/chat_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      color: orangeLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChatScreen(user: widget.user)));
        },
        child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

              if (list.isNotEmpty) {
                _message = list[0];
              }
              return ListTile(
                leading: InkWell(
                  borderRadius: BorderRadius.circular(13),
                  onTap: () {},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: CachedNetworkImage(
                      width: mq.height * .055,
                      height: mq.height * .055,
                      imageUrl: widget.user.image,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                ),
                title: Text(
                  widget.user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  _message != null
                      ? _message!.type == Type.image
                          ? "Image"
                          : _message!.msg
                      : widget.user.about,
                  maxLines: 1,
                  style: _message != null &&
                          _message!.read.isEmpty &&
                          _message!.fromId != APIs.user.uid
                      ? const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic)
                      : const TextStyle(fontWeight: FontWeight.normal),
                ),
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                color: orangeNormal,
                                borderRadius: BorderRadius.circular(10)),
                          )
                        : Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                          ),
              );
            }),
      ),
    );
  }
}
