import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/model/property.dart';
import 'package:rekodi/widgets/customTextField.dart';

import '../config.dart';
import '../model/account.dart';
import '../model/unit.dart';


class Properties extends StatefulWidget {
  const Properties({Key? key}) : super(key: key);

  @override
  State<Properties> createState() => _PropertiesState();
}

class _PropertiesState extends State<Properties> {
  TextEditingController controller = TextEditingController();
  bool loading = false;
  List<Property> properties = [];
  List<Unit> allUnits = [];


  @override
  void initState() {
    super.initState();

    getProperties();
  }

  void getProperties() async {
    setState(() {
      loading = true;
    });

    String userID = Provider.of<EKodi>(context, listen: false).account.userID!;

    await FirebaseFirestore.instance.collection("users").doc(userID).get().then((value) async {

      await context.read<EKodi>().switchUser(Account.fromDocument(value));
    });

    await FirebaseFirestore.instance.collection('properties')
        .where("publisherID", isEqualTo: userID).orderBy("timestamp", descending: true).get().then((documents) {
      documents.docs.forEach((document) async {
        Property property = Property.fromDocument(document);

        properties.add(property);

        await FirebaseFirestore.instance.collection("properties").doc(property.propertyID).collection("units").get().then((value) {
          value.docs.forEach((unitDoc) {
            Unit unit = Unit.fromDocument(unitDoc);

            allUnits.add(unit);
          });
        });


      });
    });


    setState(() {
      loading = false;
    });

  }

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
          const SizedBox(width: 10.0,),
          displayUserProfile(account),
          const SizedBox(width: 20.0,),
        ],
        bottom: PreferredSize(
          preferredSize: Size(size.width, 60.0),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: size.width*0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text("Name", style: TextStyle(color: Colors.white),),
                Text("Tenants", style: TextStyle(color: Colors.white)),
                Text("Due Date", style: TextStyle(color: Colors.white)),
                Text("OutStanding Balance", style: TextStyle(color: Colors.white)),
                Text("Status", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
          shrinkWrap: true,
          itemCount: properties.length,
          itemBuilder: (context, index) {
            Property property = properties[index];

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/property_details", arguments: property);
                },
                child: Card(
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)
                  ),
                  child: SizedBox(
                    height: 60.0,
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: size.width*0.1,
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.house_rounded, color: Colors.grey, size: 30.0,),
                            title: Text(property.name!, overflow: TextOverflow.ellipsis,),
                            subtitle: Text(property.city!+", "+property.country!),
                          ),
                        ),
                        Text("0"),
                        Text("not stated"),
                        Text("KES 0"),
                        Text("vacant")
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
