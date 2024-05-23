import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chatchit/models/chat_user.dart';
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
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      color: orangeLight,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: () {},
        child: ListTile(
          leading: InkWell(
            borderRadius: BorderRadius.circular(13),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ChatScreen()));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: CachedNetworkImage(
                width: mq.height * .055,
                height: mq.height * .055,
                imageUrl: widget.user.image,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
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
            widget.user.about,
            maxLines: 1,
          ),
          trailing: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
    );
  }
}
