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
import 'package:responsive_builder/responsive_builder.dart';
import 'package:uuid/uuid.dart';

import '../model/account.dart';
import '../model/unit.dart';


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
  TextEditingController unitName = TextEditingController();
  TextEditingController unitDesc = TextEditingController();
  List<Unit> units = [];
  bool isMultiUnit = false;
  String propertyID = Uuid().v4();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      country.text = "Kenya";
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
        units: isMultiUnit ? units.length : 1,
        publisherID: userID,
        vacant: isMultiUnit ? units.length : 1,
        occupied: 0
      );

      await FirebaseFirestore.instance.collection('properties').doc(property.propertyID).set(property.toMap()).then((value) async {
          if(isMultiUnit)
            {
              units.forEach((unit) async {
                await FirebaseFirestore.instance.collection('properties').doc(property.propertyID)
                    .collection("units").doc(unit.unitID.toString()).set(unit.toMap());
              });
            }
          else
            {
              Unit unit = Unit(
                unitID: property.timestamp,
                name: name.text.trim(),
                description: notes.text.trim(),
                tenantInfo: {},
                isOccupied: false,
                rent: 0,
                dueDate: 0,
                propertyID: property.propertyID,
                deposit: 0,
                startDate: 0,
                paymentFreq: "",
                reminder: 0,
              );

              await FirebaseFirestore.instance.collection('properties').doc(property.propertyID)
                  .collection("units").doc(unit.unitID.toString()).set(unit.toMap());
            }
      });

      Navigator.pop(context, "uploaded");

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

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {

        bool isDesktop = sizeInfo.isDesktop;

        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black,),
              onPressed: () {
                Navigator.pop(context, "canceled");
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Container(
                  height: 40.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), bottomLeft: Radius.circular(25.0))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18.0),
                          child: account.photoUrl!  == ""
                              ? Image.asset("assets/profile.png", height: 36.0, width: 36.0,)
                              : Image.network(account.photoUrl!, height: 36.0, width: 36.0,),
                        ),
                        const SizedBox(width: 5.0,),
                        Text(account.name!, style: const TextStyle(color: Colors.black),)
                      ],
                    ),
                  ),
                ),
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
                top: 0.0,
                right: 0.0,
                left: 0.0,
                bottom: 0.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: isDesktop ? 60.0 : 30.0,),
                          //Container(width: size.width, height: 1.0,color: Colors.black,),
                          const SizedBox(height: 30.0,),
                          Text("Add New Property", textAlign: TextAlign.start, style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: isDesktop ? 40.0 : 20.0, )),
                          const SizedBox(height: 10.0,),
                          Container(
                            width: isDesktop ? size.width*0.4 : size.width*0.95,
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
                                const SizedBox(height: 20.0,),
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
                                      width:isDesktop ? size.width*0.15 : size.width*0.35,
                                      title: "Country",
                                    ),
                                    MyTextField(
                                      controller: city,
                                      hintText: "city",
                                      width:isDesktop ? size.width*0.15 : size.width*0.35,
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
                                      width:isDesktop ? size.width*0.15 : size.width*0.35,
                                      title: "Town",
                                    ),
                                    MyTextField(
                                      controller: address,
                                      hintText: "Physical Address",
                                      width:isDesktop ? size.width*0.15 : size.width*0.35,
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
                                    ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                MyTextField(
                                                    controller: unitName,
                                                    hintText: "Name",
                                                    width: size.width*0.2,
                                                    title: "Unit Name",
                                                  ),
                                                MyTextField(
                                                  controller: unitDesc,
                                                  hintText: "Description",
                                                  width: size.width*0.2,
                                                  title: "Description",
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 5.0,),
                                            TextButton.icon(
                                              label: const Text("Add", style: TextStyle(color: Colors.teal),),
                                              icon: const Icon(Icons.add, color: Colors.teal,),
                                              onPressed: () async {
                                                units.add(Unit(
                                                    name: unitName.text,
                                                    description: unitDesc.text,
                                                  unitID: DateTime.now().millisecondsSinceEpoch,
                                                  tenantInfo: {},
                                                  isOccupied: false,
                                                  rent: 0,
                                                  dueDate: 0,
                                                  propertyID: propertyID,
                                                  deposit: 0,
                                                  startDate: 0,
                                                  paymentFreq: "",
                                                  reminder: 0,
                                                ));

                                                setState(() {
                                                  unitName.clear();
                                                  unitDesc.clear();
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: List.generate(units.length, (index) {
                                            return Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                              child: Card(
                                                elevation: 3.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(5.0)
                                                ),
                                                child: ListTile(
                                                  hoverColor: Colors.grey.shade300,
                                                  title: Text(units[index].name!),
                                                  subtitle: Text(units[index].description!),
                                                  trailing: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        units.remove(units[index]);
                                                      });
                                                    },
                                                    icon: const Icon(Icons.cancel_outlined, color: Colors.red,),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                        )
                                      ],
                                    )
                                    : Container(),
                                MyTextField(
                                  controller: notes,
                                  hintText: "Notes",
                                  width:  size.width,
                                  title: "Notes",
                                  inputType: TextInputType.multiline,
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
                    ),
                    const SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
