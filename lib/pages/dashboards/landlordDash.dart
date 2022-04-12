import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/model/tabItem.dart';

import '../../config.dart';
import '../../model/account.dart';


class LandlordDash extends StatefulWidget {
  const LandlordDash({Key? key}) : super(key: key);

  @override
  State<LandlordDash> createState() => _LandlordDashState();
}

class _LandlordDashState extends State<LandlordDash> {
  String selected = 'Dashboard';

  displayUserProfile(Account account) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: account.photoUrl!  == ""
              ? Image.asset("assets/profile.png", height: 36.0, width: 36.0,)
              : Image.network(account.photoUrl!, height: 36.0, width: 36.0,),
        ),
        const SizedBox(width: 10.0,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(account.name!, style: const TextStyle(color: Colors.white, fontSize: 13.0),),
            Text(account.accountType!, style: const TextStyle(color: Colors.white30, fontSize: 11.0),)
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Account account = context.watch<EKodi>().account;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Row(
          children: [
            RichText(
              text: TextSpan(
                //style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(text: 'e-', style: GoogleFonts.titanOne(color: Colors.blue, fontSize: 20.0)),
                  TextSpan(text: 'KODI', style: GoogleFonts.titanOne(color: Colors.red, fontSize: 20.0)),
                ],
              ),
            ),
            const SizedBox(width: 10.0,),
            const VerticalDivider(color: Colors.grey,),
             Icon(Icons.phone, color: Colors.blueAccent.shade700, size: 15.0,),
            const SizedBox(width: 10.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("+254-797-383-995", style: TextStyle(color: Colors.white, fontSize: 13.0),),
                Text("Help & Support", style: TextStyle(color: Colors.white30, fontSize: 11.0),),
              ],
            )
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
            child: RaisedButton.icon(
              label: const Text("New Property", style: TextStyle(color: Colors.white),),
              color: Colors.teal,
              elevation: 0.0,
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.white,),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_active_rounded, color: Colors.white30,),
          ),
          const SizedBox(width: 10.0,),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.question_answer_outlined, color: Colors.white30,),
          ),
          const SizedBox(width: 10.0,),
          displayUserProfile(account),
          const SizedBox(width: 20.0,),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: size.width,
            height: 40.0,
            decoration: const BoxDecoration(
                color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 0.0),
                  spreadRadius: 2.0,
                  blurRadius: 2.0
                )
              ]
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(tabItems.length, (index) {
                      TabItem item = tabItems[index];
                      bool isSelected = selected == item.name;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selected = item.name!;
                            });
                          },
                          child: Container(
                            height: 40.0,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(width: 2.0, color: isSelected ? Colors.deepPurple.shade900 : Colors.transparent),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(item.iconData!, color: isSelected ? Colors.deepPurple.shade900 : Colors.grey, size: 15.0,),
                                const SizedBox(width: 5.0,),
                                Text(item.name!, style: Theme.of(context).textTheme.caption!.apply(color: isSelected ? Colors.deepPurple.shade900 : Colors.grey, fontWeightDelta: 2),)
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  //TODO: Put search widget here
                  Container()
                ],
              ),
            ),
          ),
          SizedBox(
            width: size.width,
            height: 60.0,
            child:  Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(selected, style: Theme.of(context).textTheme.titleSmall!.apply(color: Colors.black, fontWeightDelta: 10),),
                      Text("Hi ${account.name!}, Welcome to e-Ekodi", style: TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Container(
                    height: 30.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          spreadRadius: 1.0,
                          offset: Offset(0.0, 0.0)
                        )
                      ],
                      border: Border.all(width: 0.5, color: Colors.grey.shade300)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.date_range_rounded, color: Colors.grey,size: 15.0,),
                        SizedBox(width: 5.0,),
                        Text("Jan 2022 - Apr 2022", style: TextStyle(color: Colors.grey, fontSize: 13.0, fontWeight: FontWeight.bold),),
                        SizedBox(width: 5.0,),
                        Icon(Icons.arrow_drop_down, color: Colors.grey,),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Container(),//TODO:
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Container(
                        width: size.width,
                        height: 100.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.0),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                  spreadRadius: 1.0,
                                  offset: Offset(0.0, 0.0)
                              )
                            ],
                            border: Border.all(width: 0.5, color: Colors.grey.shade300)
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
