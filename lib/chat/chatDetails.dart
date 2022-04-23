import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/chat/chatProvider/chatProvider.dart';
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

  AppBar _buildProviderAppBar(ServiceProvider account) {
    return AppBar(
      backgroundColor: Colors.black,
      title: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child:  account.photoUrl!  == ""
              ? Image.asset("assets/profile.png", height: 30.0, width: 30.0, fit: BoxFit.cover,)
              : Image.network(account.photoUrl!, height: 30.0, width: 30.0,fit: BoxFit.cover),
        ),
        title: Text(account.title!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        subtitle: Text(account.phone!, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white),),
      ),
    );
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
    );
  }

  @override
  Widget build(BuildContext context) {
    Account currentAccount = context.watch<EKodi>().account;
    ServiceProvider currentProvider = context.watch<EKodi>().serviceProvider;
    //bool isCurrentProvider = context.watch<EKodi>().isServiceProvider;
    Size size = MediaQuery.of(context).size;
    //String docID = isServiceProvider ? currentProvider.providerID! : currentAccount.userID!;

    bool isNull = context.watch<ChatProvider>().serviceProvider.providerID == null && context.watch<EKodi>().account.userID == null;

    Account receiverAccount = context.watch<ChatProvider>().receiverAccount;
    ServiceProvider receiverProvider = context.watch<ChatProvider>().serviceProvider;
    bool isReceiverProvider = context.watch<ChatProvider>().isServiceProvider;

    return Scaffold(
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: AuthTextField(
              controller: controller,
              prefixIcon: const Icon(Icons.translate_rounded, color: Colors.grey,),
              hintText: "Type something...",
              isObscure: false,
              inputType: TextInputType.text,
            ),
          ),
          FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.send_rounded, color: Colors.white,),
          )
        ],
      ),
      appBar: isNull
          ?  AppBar(title: Text("Chats", style: TextStyle(color: Colors.white),), backgroundColor: Colors.black,)
          : isReceiverProvider ? _buildProviderAppBar(receiverProvider) : _buildAccountAppBar(receiverAccount),
      body: isNull ? LoadingAnimation() : Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            left: 0.0,
            bottom: 60.0,
            child: Container(color: Colors.grey,),
          )
        ],
      ),
    );
  }
}
