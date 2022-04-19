import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../config.dart';
import '../model/account.dart';
import '../model/property.dart';
import '../model/unit.dart';
import '../widgets/customTextField.dart';

class AddTenant extends StatefulWidget {
  const AddTenant({Key? key}) : super(key: key);

  @override
  State<AddTenant> createState() => _AddTenantState();
}

class _AddTenantState extends State<AddTenant> {
  int startDate = DateTime.now().millisecondsSinceEpoch;
  TextEditingController rent = TextEditingController();
  TextEditingController deposit = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController reminder = TextEditingController();
  TextEditingController tenantEmail = TextEditingController();
  String paymentFreq = 'Monthly';
  List<Unit> allUnits = [];
  late Unit selectedUnit;


  @override
  void initState() {
    super.initState();

    getUnits();
  }

  getUnits() async {
    Property property = ModalRoute.of(context)!.settings.arguments as Property;

    await FirebaseFirestore.instance.collection("properties").doc(property.propertyID).collection("units").get().then((querySnapshot) {
      querySnapshot.docs.forEach((element) {
        Unit unit = Unit.fromDocument(element);

        allUnits.add(unit);
      });
    });
  }

  addTenantToUnit() async {

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

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      // if (args.value is PickerDateRange) {
      //   // String _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
      //   // // ignore: lines_longer_than_80_chars
      //   //     ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      //
      // }
      // else
        if (args.value is DateTime) {
        startDate = args.value.millisecondsSinceEpoch;
      }
      //   else if (args.value is List<DateTime>) {
      //   _dateCount = args.value.length.toString();
      // } else {
      //   _rangeCount = args.value.length.toString();
      // }
    });
  }

  displayCalendar(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Pick Starting Date"),
          content: Container(
            height: size.height*0.6,
            width: size.width*0.4,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              onSelectionChanged: _onSelectionChanged,
              enableMultiView: true,
              selectionMode: DateRangePickerSelectionMode.single,
              initialSelectedDate: DateTime.fromMillisecondsSinceEpoch(startDate),
              // initialSelectedRange: PickerDateRange(
              //     DateTime.fromMillisecondsSinceEpoch(startDate),
              //     DateTime.fromMillisecondsSinceEpoch(endDate)
              // ),
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {Navigator.pop(context);},
              icon: Icon(Icons.done, color: Theme.of(context).primaryColor),
              label: Text("Done", style: TextStyle(color: Theme.of(context).primaryColor),),
            )
          ],
        );
      },
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add New Tenant", textAlign: TextAlign.start, style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 40.0, )),
            const SizedBox(height: 10.0,),
            Container(
              width: size.width*0.6,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Select Unit"),
                  ListView.builder(
                    itemCount: allUnits.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Unit unit = allUnits[index];
                      bool isSelected = unit == selectedUnit;

                      return Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              selectedUnit = unit;
                            });
                          },
                          leading: isSelected
                              ? const Icon(Icons.check_box, color: Colors.teal,)
                              : const Icon(Icons.check_box_outline_blank_rounded, color: Colors.grey,),
                          title: Text(unit.name!),
                          subtitle: Text(unit.isOccupied! ? "Occupied" : "Vacant"),
                        ),
                      );
                    },
                  ),
                  Text("Start Date"),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(startDate))),
                      const SizedBox(width: 5.0,),
                      IconButton(
                        onPressed: () => displayCalendar(context),
                        icon: const Icon(Icons.date_range_rounded, color: Colors.grey,),
                      )
                    ],
                  ),
                  MyTextField(
                    controller: tenantEmail,
                    hintText: "Email Address",
                    width:  size.width,
                    title: "Tenant Email Address",
                  ),
                  MyTextField(
                    controller: rent,
                    hintText: "Rent Amount",
                    width:  size.width,
                    title: "Rent Amount (KES)",
                  ),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Payment Frequency?", style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
                      )
                  ),
                  const SizedBox(height: 5.0,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                    child: DropdownSearch<String>(
                        mode: Mode.MENU,
                        showSelectedItems: true,
                        items: const [
                          "One-Time(Airbnb)",
                          "Weekly",
                          "Monthly",
                          "Bi-Annually(6 Months)",
                          "Yearly"
                        ],
                        hint: "Is this property a multi-unit?",
                        onChanged: (v) {
                          setState(() {
                            paymentFreq = v!;
                          });
                        },
                        selectedItem: paymentFreq),
                  ),
                  MyTextField(
                    controller: deposit,
                    hintText: "Deposit Amount",
                    width:  size.width,
                    title: "Deposit Amount (KES)",
                  ),
                  MyTextField(
                    controller: notes,
                    hintText: "Notes",
                    width:  size.width,
                    title: "Type something here...",
                  ),
                  MyTextField(
                    controller: reminder,
                    hintText: "0 days",
                    width:  size.width,
                    title: "Tenant Rent Reminder Days Before",
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RaisedButton.icon(
                        onPressed: addTenantToUnit,
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
    );
  }
}
