import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/chat/chatProvider/chatProvider.dart';
import 'package:rekodi/chat/models/message.dart';
import 'package:rekodi/widgets/customTextField.dart';
import 'package:rekodi/widgets/loadingAnimation.dart';

import '../config.dart';
import '../model/account.dart';
import '../model/serviceProvider.dart';


class ChatDetails extends StatefulWidget {
  const ChatDetails({Key? key,}) : super(key: key);

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  TextEditingController controller = TextEditingController();
  bool loading = false;
  List<Message> messages = [];
  late Stream messageStream;


  @override
  void initState() {
    getMessages();
    super.initState();
  }

  getMessages() async {
    setState(() {
      loading = true;
    });

    String currentUserID = Provider.of<EKodi>(context, listen: false).account.userID!;
    String receiverID = Provider.of<EKodi>(context, listen: false).account.userID!;

    await FirebaseFirestore.instance.collection("users").doc(currentUserID)
        .collection("messages").where("chatID", arrayContains: receiverID).orderBy("timestamp", descending: true).get()
        .then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            messages.add(Message.fromDocument(element));
          });
    });

    setState(() {
      loading = false;
      controller.clear();
    });
  }

  sendMessage(Account sender, Account receiver) async {
    Message message = Message(
      messageID: DateTime.now().millisecondsSinceEpoch.toString(),
      senderID: sender.userID,
      chatID: [sender.userID!, receiver.userID!],
      imageUrl: "",
      receiverID: receiver.userID,
      messageDescription: controller.text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      isWithImage: false,
      seen: false,
      senderInfo: sender.toMap(),
      receiverInfo: receiver.toMap(),
    );

    await FirebaseFirestore.instance.collection("users").doc(sender.userID)
        .collection("messages").doc(message.messageID).set(message.toMap());

    await FirebaseFirestore.instance.collection("users").doc(receiver.userID)
        .collection("messages").doc(message.messageID).set(message.toMap());

    Fluttertoast.showToast(msg: "Message Sent");
    await getMessages();
  }

  AppBar _buildAccountAppBar(Account account) {
    return AppBar(
      backgroundColor: Colors.black,
      title: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child:  account.photoUrl!  == ""
              ? Image.asset("assets/profile.png", height: 30.0, width: 30.0, fit: BoxFit.cover,)
              : Image.network(account.photoUrl!, height: 30.0, width: 30.0,fit: BoxFit.cover),
        ),
        title: Text(account.name!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        subtitle: Text(account.phone!, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white),),
      ),
      actions: [
        IconButton(
          onPressed: () {
            context.read<ChatProvider>().openChatDetails(false);
          },
          icon: const Icon(Icons.clear, color: Colors.white,),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Account currentAccount = context.watch<EKodi>().account;
    Account receiverAccount = context.watch<ChatProvider>().receiverAccount;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0)
                ),
                child: AuthTextField(
                  controller: controller,
                  prefixIcon: const Icon(Icons.translate_rounded, color: Colors.grey,),
                  hintText: "Type something...",
                  isObscure: false,
                  inputType: TextInputType.text,
                ),
              ),
            ),
          ),
          FloatingActionButton(
            onPressed: () {
              if(controller.text.isNotEmpty)
                {
                  sendMessage(currentAccount, receiverAccount);
                }
            },
            child: const Icon(Icons.send_rounded, color: Colors.white,),
          )
        ],
      ),
      appBar: _buildAccountAppBar(receiverAccount),
      body: Stack(
        children: [
          Image.asset("assets/chat.jpg", width: size.width, height: size.height, fit: BoxFit.cover,),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            bottom: 60.0,
            child: loading
                ? const Center(child: Text("Loading..."),)
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(messages.length, (index) {
                        Message message = messages[index];
                        bool isMine = message.senderID == currentAccount.userID;

                        return Align(
                          alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 5.0,
                              bottom: 5.0,
                              left: isMine ? size.width*0.1 : 5.0,
                              right: isMine ? 5.0 : size.width*0.1,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isMine ? Colors.white : Theme.of(context).primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    topLeft: isMine ? Radius.circular(10.0) : Radius.circular(0.0),
                                  topRight: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                  bottomRight: isMine ? Radius.circular(0.0) : Radius.circular(10.0),
                                )
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(message.messageDescription!, maxLines: 50, overflow: TextOverflow.ellipsis,),
                                  SizedBox(height: 2.0,),
                                  Text(DateFormat("HH:mm, dd MMM").format(DateTime.fromMillisecondsSinceEpoch(message.timestamp!)), style: TextStyle(color: Colors.grey, fontSize: 8.0),)
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
