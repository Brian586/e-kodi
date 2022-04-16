import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../config.dart';
import '../../model/account.dart';


class TenantDash extends StatefulWidget {
  const TenantDash({Key? key}) : super(key: key);

  @override
  State<TenantDash> createState() => _TenantDashState();
}

class _TenantDashState extends State<TenantDash> {


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
      backgroundColor: Colors.grey.shade50,
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
    );
  }
}
