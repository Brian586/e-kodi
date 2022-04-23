import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
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
            
            await FirebaseFirestore.instance.collection("properties").doc(property.propertyID)
                .collection("units").where("isOccupied", isEqualTo: true).get().then((value) {
                  value.docs.forEach((unitSnap) async { 
                    Unit unit = Unit.fromDocument(unitSnap);
                    
                    await FirebaseFirestore.instance.collection("users").where("userID", isEqualTo: unit.tenantID).get().then((snap) {
                      snap.docs.forEach((acc) {
                        myTenants.add(Account.fromDocument(acc));
                      });
                    });
                  });
            });
          });
    });

    setState(() {
      loading = false;
    });
  }

  // displayDialog(BuildContext context, Account account) {
  //   Size size = MediaQuery.of(context).size;
  //
  //   showDialog(
  //     context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext dialogContext) {
  //       return AlertDialog(
  //         title: Text("My Tenants", style: GoogleFonts.baloo2()),
  //         content: Container(
  //           height: size.height*0.6,
  //           width: size.width*0.4,
  //           decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(20.0)
  //           ),
  //           child: FutureBuilder<QuerySnapshot>(
  //             future: FirebaseFirestore.instance.collection("properties")
  //                 .where("publisherID", isEqualTo: account.userID).where("occupied", isGreaterThan: 0).get(),
  //             builder: (context, snapshot) {
  //               if(!snapshot.hasData)
  //                 {
  //                   return LoadingAnimation();
  //                 }
  //               else 
  //                 {
  //                   List<Account> tenants = [];
  //                   List<Property> properties = [];
  //                   List<Unit> units = [];
  //                  
  //                   snapshot.data!.docs.forEach((element) { 
  //                     properties.add(Property.fromDocument(element));
  //                   });
  //                  
  //                   if(properties.isEmpty)
  //                     {
  //                       return const Center(
  //                         child: Text("You don't have tenants", style: TextStyle(color: Colors.grey),),
  //                       );
  //                     }
  //                   else 
  //                     {
  //                       for(int i = 0; i < properties.length; i++)
  //                         {
  //                           return FutureBuilder<QuerySnapshot>(
  //                             future: FirebaseFirestore.instance.collection("properties")
  //                                 .doc(properties[i].propertyID).collection("units").where("dueDate", isNotEqualTo: 0).get(),
  //                             builder: (context, snap) {
  //                               if(!snap.hasData)
  //                                 {
  //                                   return LoadingAnimation();
  //                                 }
  //                               else
  //                                 {
  //
  //                                   snap.data!.docs.forEach((element) {
  //                                     units.add(Unit.fromDocument(element));
  //                                   });
  //
  //
  //                                 }
  //                             },
  //                           );
  //                         }
  //                     }
  //                 }
  //             },
  //           ),
  //         ),
  //       );
  //       }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    Account account = context.watch<EKodi>().account;
    //ServiceProvider provider = context.watch<EKodi>().serviceProvider;
    // bool isServiceProvider = context.watch<EKodi>().isServiceProvider;
    Size size = MediaQuery.of(context).size;
    // String docID = isServiceProvider ? provider.providerID! : account.userID!;

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
                return loading ? LoadingAnimation() : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(myTenants.length, (index) {
                      Account tenant = myTenants[index];

                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
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
                );
              }
            else
              {
                return GroupedListView<dynamic, Message>(
                  elements: messages,
                  groupBy: (message) => message.messageID,
                  //groupSeparatorBuilder: (Message groupByValue) => Text(groupByValue.),
                  itemBuilder: (context, dynamic message) => Text(message.senderID),
                  //itemComparator: (item1, item2) => item1['name'].compareTo(item2['name']), // optional
                  useStickyGroupSeparators: true, // optional
                  floatingHeader: true, // optional
                  order: GroupedListOrder.ASC, // optional
                );
              }
          }
        },
      ),
    );
  }


}
