import 'package:flutter/material.dart';
import 'package:chatchit/ui/common/app_colors.dart';
import 'package:chatchit/ui/common/ui_helpers.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      color: orangeLightActive,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: InkWell(
        onTap: () {},
        child: const ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(
            "VU tran",
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            "TIn nhan gan nhat",
            maxLines: 1,
          ),
          trailing: Text(
            "12:00 AM",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
