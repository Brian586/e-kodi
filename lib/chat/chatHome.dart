import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/chat/chatProvider/chatProvider.dart';
import 'package:rekodi/chat/models/message.dart';
import 'package:rekodi/model/property.dart';
import 'package:rekodi/model/serviceProvider.dart';
import 'package:rekodi/model/unit.dart';
import 'package:rekodi/widgets/customTextField.dart';
import 'package:rekodi/widgets/loadingAnimation.dart';

import '../config.dart';
import '../model/account.dart';


class ChatHome extends StatefulWidget {

  const ChatHome({Key? key,}) : super(key: key);

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  List<Account> myTenants = [];
  List<Property> properties = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();

    getTenants();
  }

  getTenants() async {
    setState(() {
      loading = true;
    });

    String userID = Provider.of<EKodi>(context, listen: false).account.userID!;

    await FirebaseFirestore.instance.collection("properties").where("publisherID", isEqualTo: userID)
        .where("occupied", isGreaterThan: 0).get().then((querySnapshot) async {
          querySnapshot.docs.forEach((prop) async {
            Property property = Property.fromDocument(prop);

            properties.add(property);
          });
    });

    for(int i = 0; i < properties.length; i++)
      {
        await FirebaseFirestore.instance.collection("properties").doc(properties[i].propertyID)
            .collection("units").where("isOccupied", isEqualTo: true).get().then((value) {
          value.docs.forEach((unitSnap) async {
            Unit unit = Unit.fromDocument(unitSnap);

            Account tenant = Account(
              userID: unit.tenantInfo!["userID"],
              name: unit.tenantInfo!["name"],
              email: unit.tenantInfo!["email"],
              phone: unit.tenantInfo!["phone"],
              idNumber: unit.tenantInfo!["idNumber"],
              accountType: unit.tenantInfo!["accountType"],
              photoUrl:unit.tenantInfo!["photoUrl"],
            );

            myTenants.add(tenant);


          });
        });
      }


    setState(() {
      loading = false;
    });


  }

  displayTenants() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: Colors.grey.shade300,),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text("My Tenants", style: Theme.of(context).textTheme.titleSmall,),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(myTenants.length, (index) {
            Account tenant = myTenants[index];

            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () async {
                  await context.read<ChatProvider>().switchAccount(tenant);
                  context.read<ChatProvider>().openChatDetails(true);
                },
                child: Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: tenant.photoUrl!  == ""
                          ? Image.asset("assets/profile.png", height: 30.0, width: 30.0, fit: BoxFit.cover,)
                          : Image.network(tenant.photoUrl!, height: 30.0, width: 30.0,fit: BoxFit.cover),
                    ),
                    title: Text(tenant.name!, style: const TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(tenant.phone!, maxLines: 3, overflow: TextOverflow.ellipsis,),
                    // trailing: Column(
                    //   mainAxisSize: MainAxisSize.min,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Icon(Icons.star_rate_outlined, color: Colors.grey,),
                    //     Text("${provider.rating} rating")
                    //   ],
                    // ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Account account = context.watch<EKodi>().account;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Messages", style: GoogleFonts.baloo2(color: Colors.white),),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").doc(account.userID!).collection("messages").orderBy("timestamp").snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            {
              return const LoadingAnimation();
            }
          else {
            List<Message> messages = [];

            snapshot.data!.docs.forEach((element) {
              messages.add(Message.fromDocument(element));
            });

            if(messages.isEmpty)
              {
                return loading ? LoadingAnimation() : displayTenants();
              }
            else
              {
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text("Recent Chats", style: Theme.of(context).textTheme.titleSmall,),
                      ),
                      GroupedListView<dynamic, Message>(
                        elements: messages,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        groupBy: (message) => message.chatID,
                        //groupSeparatorBuilder: (Message groupByValue) => Text(groupByValue.),
                        groupHeaderBuilder: (m) => Container(),
                        groupSeparatorBuilder: (m) => Container(),
                        itemBuilder: (context, dynamic message) {
                          bool isMe = message.senderID == account.userID;

                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () async {
                                // await context.read<ChatProvider>().switchAccount(message.rec);
                                // context.read<ChatProvider>().openChatDetails(true);
                              },
                              child: Card(
                                child: ListTile(
                                  // leading: ClipRRect(
                                  //   borderRadius: BorderRadius.circular(15.0),
                                  //   child: message.receiverInfo!["photoUrl"]!  == ""
                                  //       ? Image.asset("assets/profile.png", height: 30.0, width: 30.0, fit: BoxFit.cover,)
                                  //       : Image.network(tenant.photoUrl!, height: 30.0, width: 30.0,fit: BoxFit.cover),
                                  // ),
                                  title: Text(isMe ? message.receiverInfo!["name"] : message.senderInfo!["name"], style: const TextStyle(fontWeight: FontWeight.bold),),
                                  subtitle: Text(isMe ? "You: ${message.messageDescription!}" : message.messageDescription!, maxLines: 1, overflow: TextOverflow.ellipsis,),
                                  // trailing: Column(
                                  //   mainAxisSize: MainAxisSize.min,
                                  //   crossAxisAlignment: CrossAxisAlignment.center,
                                  //   children: [
                                  //     Icon(Icons.star_rate_outlined, color: Colors.grey,),
                                  //     Text("${provider.rating} rating")
                                  //   ],
                                  // ),
                                ),
                              ),
                            ),
                          );
                        },
                        //itemComparator: (item1, item2) => item1['name'].compareTo(item2['name']), // optional
                        // useStickyGroupSeparators: true, // optional
                        // floatingHeader: true, // optional
                        // order: GroupedListOrder.ASC, // optional
                      ),
                      displayTenants()
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }


}
