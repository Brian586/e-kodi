import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/model/property.dart';
import 'package:rekodi/pages/addTenant.dart';
import 'package:rekodi/widgets/loadingAnimation.dart';

import '../config.dart';
import '../model/account.dart';
import '../model/unit.dart';

class PropertyDetails extends StatefulWidget {
  final Property? property;

  const PropertyDetails(this.property,{Key? key, }) : super(key: key);

  @override
  State<PropertyDetails> createState() => _PropertyDetailsState();
}

class _PropertyDetailsState extends State<PropertyDetails> {
  List<Unit> units = [];
  bool loading = false;

  @override
  void initState() {
    getUnits();
    super.initState();
  }

  void getUnits() async {
    setState(() {
      loading = true;
    });

    await FirebaseFirestore.instance.collection("properties").doc(widget.property!.propertyID).collection("units").get().then((value) {
      value.docs.forEach((element) {
        units.add(Unit.fromDocument(element));
      });
    });

    setState(() {
      loading = false;
    });
  }

  proceedToAddTenant() async {

    //TODO: Remember to check if all units are occupied before adding tenant

    Route route = MaterialPageRoute(builder: (context)=> AddTenant(widget.property));

    String res = await Navigator.push(context, route);

    //get tenant details

    if(res == "uploaded"){
      setState(() {
        units.clear();
        loading = true;
      });

      await FirebaseFirestore.instance.collection("properties").doc(widget.property!.propertyID).collection("units").get().then((value) {
        value.docs.forEach((element) {
          units.add(Unit.fromDocument(element));
        });
      });

      setState(() {
        loading = false;
      });
    }
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

  Widget showUnits(Size size) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: size.width*0.5/200.0,
      children: List.generate(units.length, (index) {
        Unit unit = units[index];
        String date = DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(unit.startDate!));

        return Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: SizedBox(
            height: 100.0,
            width:  size.width*0.5,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.house_rounded, color: Colors.grey, ),
                  title: Text(unit.name!, style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text(unit.description!, maxLines: 3, overflow: TextOverflow.ellipsis,),
                  trailing: unit.isOccupied! ? const Text("Occupied", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold) ) : const Text("Vacant", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                ),
                unit.isOccupied! ? ListTile(
                  title: Text("Occupied By: ${unit.tenantInfo!["name"]}", maxLines: 2, overflow: TextOverflow.ellipsis,),
                  subtitle: Text("From $date to Date"),
                  trailing: Text("Rent: KES ${unit.rent.toString()}", style: const TextStyle(fontWeight: FontWeight.bold),),
                ) : Container()
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    Account account = context.watch<EKodi>().account;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
      ),
      body: loading ? LoadingAnimation(): SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () {Navigator.pop(context);},
              icon: Icon(Icons.arrow_back_rounded, color: Colors.grey,),
              label: Text("Back", style: TextStyle(color: Colors.grey),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: size.width*0.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, 0.0),
                                  spreadRadius: 2.0,
                                  blurRadius: 2.0
                              )
                            ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Property Details", style: Theme.of(context).textTheme.titleMedium,),
                              const Divider(color: Colors.grey,),
                              Text(widget.property!.name!, style: Theme.of(context).textTheme.bodyMedium,),
                              Text("${widget.property!.address!}, ${widget.property!.city!} ${widget.property!.country!}", style: Theme.of(context).textTheme.bodyMedium,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3.0),
                                      border: Border.all(
                                        color: Colors.blue,
                                        width: 1.0
                                      )
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Center(child: Text("Manage images for your property", style: TextStyle(color: Colors.blue),)),
                                    ),
                                  ),
                                  const SizedBox(width: 5.0,),
                                  Container(
                                    height: 25.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3.0),
                                        border: Border.all(
                                            color: Colors.blue,
                                            width: 1.0
                                        )
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Center(child: Text("Edit Property", style: TextStyle(color: Colors.blue),)),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: size.width*0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0.0, 0.0),
                                  spreadRadius: 2.0,
                                  blurRadius: 2.0
                              )
                            ]
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 50.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.location_off_outlined, color: Colors.grey,),
                                SizedBox(height: 10.0,),
                                Text("No location information", style: TextStyle(color: Colors.grey,),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:size.width*0.1, vertical: 10.0),
              child: Text("Property Units", style: Theme.of(context).textTheme.headlineSmall,),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:size.width*0.1),
              child: showUnits(size),
            ),
            widget.property!.vacant == 0 ? Container() : Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 10.0),
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 0.0),
                          spreadRadius: 2.0,
                          blurRadius: 2.0
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Leases/Tenancies", style: Theme.of(context).textTheme.titleMedium!.apply(fontWeightDelta: 2),),
                          InkWell(
                            onTap: proceedToAddTenant,
                            child: Container(
                              height: 25.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  border: Border.all(
                                      color: Colors.blue,
                                      width: 1.0
                                  )
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Center(child: Text("Add New Tenant", style: TextStyle(color: Colors.blue),)),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      Image.asset("assets/add_tenant.png", height: 80.0, width: 80.0, fit: BoxFit.contain,),
                      const SizedBox(height: 10.0,),
                      const Text("Start by adding your tenant"),
                      const SizedBox(height: 10.0,),
                      const Text("Once you add a tenant, you can start tracking your rent payments"),
                      const SizedBox(height: 10.0,),
                      RaisedButton.icon(
                          onPressed: proceedToAddTenant,
                          color: Colors.blue,
                          icon: const Icon(Icons.person_add, color: Colors.white,),
                          label: const Text("Add new tenant", style: TextStyle(color: Colors.white),)
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 10.0),
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 0.0),
                          spreadRadius: 2.0,
                          blurRadius: 2.0
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Property Documents", style: Theme.of(context).textTheme.titleMedium!.apply(fontWeightDelta: 2),),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              height: 25.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  border: Border.all(
                                      color: Colors.blue,
                                      width: 1.0
                                  )
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Center(child: Text("Add Document", style: TextStyle(color: Colors.blue),)),
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(color: Colors.grey,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment, color: Colors.grey.shade400, size: 40.0,),
                          const SizedBox(height: 10.0,),
                          const Text("No documents added", style: TextStyle(color: Colors.grey),)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 10.0),
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 0.0),
                          spreadRadius: 2.0,
                          blurRadius: 2.0
                      )
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Expenses", style: Theme.of(context).textTheme.titleMedium!.apply(fontWeightDelta: 2),),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              height: 25.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  border: Border.all(
                                      color: Colors.blue,
                                      width: 1.0
                                  )
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Center(child: Text("Add Expense", style: TextStyle(color: Colors.blue),)),
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(color: Colors.grey,),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.currency_exchange_rounded, color: Colors.grey.shade400, size: 40.0,),
                          const SizedBox(height: 10.0,),
                          const Text("No documents added", style: TextStyle(color: Colors.grey),)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}
