import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/chat/chatDetails.dart';
import 'package:rekodi/chat/chatHome.dart';
import 'package:rekodi/chat/chatProvider/chatProvider.dart';


class ChatBuilder extends StatefulWidget {
  const ChatBuilder({Key? key}) : super(key: key);

  @override
  State<ChatBuilder> createState() => _ChatBuilderState();
}

class _ChatBuilderState extends State<ChatBuilder> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isOpen = context.watch<ChatProvider>().isOpen;

    return Container(
      height: size.height*0.7,
      width: size.width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey.shade300, width: 1.0)),
      child: isOpen ? Row(
        children: const [
          Expanded(
            flex: 1,
            child: ChatHome(),
          ),
          Expanded(
            flex: 1,
            child: ChatDetails(),
          ),
        ],
      ) : const ChatHome(),
    );
  }
}
