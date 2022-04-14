import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/config.dart';
import 'package:rekodi/model/property.dart';
import 'package:rekodi/pages/dashboards/landlordDash.dart';
import 'package:rekodi/widgets/customTextField.dart';
import 'package:uuid/uuid.dart';

import '../model/account.dart';


class AddProperty extends StatefulWidget {
  const AddProperty({Key? key}) : super(key: key);

  @override
  State<AddProperty> createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController town = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController oneBd = TextEditingController();
  TextEditingController twoBd = TextEditingController();
  TextEditingController threeBd = TextEditingController();
  bool isMultiUnit = false;
  String propertyID = Uuid().v4();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      country.text = "Kenya";
      oneBd.text = "0";
      twoBd.text = "0";
      threeBd.text = "0";
    });
  }

  savePropertyToDatabase() async{
    if(name.text.isNotEmpty && country.text.isNotEmpty && city.text.isNotEmpty
        && address.text.isNotEmpty && town.text.isNotEmpty){

      setState(() {
        loading = true;
      });

      String userID = Provider.of<EKodi>(context, listen: false).account.userID!;

      Property property = Property(
        name: name.text.trim(),
        propertyID: propertyID,
        city: city.text.trim(),
        country: country.text.trim(),
        town: town.text.trim(),
        address: address.text.trim(),
        notes: notes.text.trim(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        units: isMultiUnit? int.parse(oneBd.text.trim())+ int.parse(twoBd.text.trim())+ int.parse(threeBd.text.trim()) : 1,

      );

      await FirebaseFirestore.instance.collection('users')
        .doc(userID).collection('properties').doc(property.propertyID).set(property.toMap());

      Navigator.pop(context);

      setState(() {
        loading = false;
      });

    } else {
      Fluttertoast.showToast(msg: "Kindly fill the required fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Account account = context.watch<EKodi>().account;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18.0),
                child: account.photoUrl!  == ""
                    ? Image.asset("assets/profile.png", height: 36.0, width: 36.0,)
                    : Image.network(account.photoUrl!, height: 36.0, width: 36.0,),
              ),
              const SizedBox(width: 5.0,),
              Text(account.email!, style: const TextStyle(color: Colors.black),)
            ],
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: loading ? Container(
          height: size.height,
          width: size.width,
          color: Colors.white,
          child: Center(child: Image.asset("assets/loading.gif"),)) : Stack(
        children: [
          Image.asset("assets/background.jpg", height: size.height, width: size.width, fit: BoxFit.cover,),
          Positioned(
            top: 0.0,
            right: 0.0,
            left: 0.0,
            bottom: 0.0,
            child: Container(width: size.width, height: size.height,color: Colors.white.withOpacity(0.4),),
          ),
          Positioned(
            top: 60.0,
            right: 0.0,
            left: 0.0,
            //bottom: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: size.width, height: 1.0,color: Colors.black,),
                    const SizedBox(height: 30.0,),
                    Text("Add New Property", textAlign: TextAlign.start, style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 40.0, )),
                    const SizedBox(height: 10.0,),
                    Container(
                      width: size.width*0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2.0,
                              spreadRadius: 2.0,
                              offset: Offset(0.0, 0.0)
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20.0,),
                          MyTextField(
                            controller: name,
                            hintText: "Name",
                            width:  size.width,
                            title: "Name of Property",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyTextField(
                                controller: country,
                                hintText: "country",
                                width:size.width*0.15,
                                title: "Country",
                              ),
                              MyTextField(
                                controller: city,
                                hintText: "city",
                                width:  size.width*0.15,
                                title: "City",
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyTextField(
                                controller: town,
                                hintText: "Town",
                                width:size.width*0.15,
                                title: "Town",
                              ),
                              MyTextField(
                                controller: address,
                                hintText: "Physical Address",
                                width:  size.width*0.15,
                                title: "Physical Address",
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Is this property a multi-unit?", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                            )
                          ),
                          const SizedBox(height: 5.0,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                            child: DropdownSearch<String>(
                                mode: Mode.MENU,
                                showSelectedItems: true,
                                items: const ["Yes", "No"],
                                hint: "Is this property a multi-unit?",
                                onChanged: (v) {
                                  setState(() {
                                    isMultiUnit = v == "Yes";
                                  });
                                },
                                selectedItem: "No"),
                          ),
                          isMultiUnit
                              ?  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  MyTextField(
                                    controller: oneBd,
                                    hintText: "How Many",
                                    width:  size.width*0.1,
                                    title: "1 Bedroom",
                                  ),
                                  MyTextField(
                                    controller: twoBd,
                                    hintText: "How Many",
                                    width:  size.width*0.1,
                                    title: "2 Bedroom",
                                  ),
                                  MyTextField(
                                    controller: threeBd,
                                    hintText: "How Many",
                                    width:  size.width*0.1,
                                    title: "3 Bedroom",
                                  ),
                                ],
                              )
                              : Container(),
                          MyTextField(
                            controller: notes,
                            hintText: "Notes",
                            width:  size.width,
                            title: "Notes",
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: RaisedButton.icon(
                              onPressed: savePropertyToDatabase,
                              icon: Icon(Icons.done_rounded, color:Colors.white),
                              label: Text("Save", style: TextStyle(color:Colors.white),),
                              color:Colors.blueAccent
                            ),
                          )
                        ],

                      ),
                    ),
                  ],
                ),
                const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
