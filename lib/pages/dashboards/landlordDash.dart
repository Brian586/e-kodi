import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart' as pie_chart;
import 'package:provider/provider.dart';
import 'package:rekodi/model/property.dart';
import 'package:rekodi/model/tabItem.dart';
import 'package:rekodi/widgets/customTextField.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../config.dart';
import '../../model/account.dart';

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}


class LandlordDash extends StatefulWidget {
  const LandlordDash({Key? key}) : super(key: key);

  @override
  State<LandlordDash> createState() => _LandlordDashState();
}

class _LandlordDashState extends State<LandlordDash> {
  String selected = 'Dashboard';
  TextEditingController searchController = TextEditingController();
  List<Property> properties = [];
  bool loading = false;
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;


  @override
  void initState() {
    super.initState();

    data = [
      _ChartData('Dec', 12),
      _ChartData('Jan', 15),
      _ChartData('Feb', 30),
      _ChartData('March', 6.4),
      _ChartData('April', 14)
    ];
    _tooltip = TooltipBehavior(enable: true);

    getUserInfo();
  }

  void getUserInfo() async {
    setState(() {
      loading = true;
    });

    String userID = Provider.of<EKodi>(context, listen: false).account.userID!;

    await FirebaseFirestore.instance.collection("users").doc(userID).get().then((value) async {

      await context.read<EKodi>().switchUser(Account.fromDocument(value));
    });

    await FirebaseFirestore.instance.collection('users')
        .doc(userID)
        .collection('properties').orderBy("timestamp", descending: true).get().then((documents) {
      documents.docs.forEach((document) {
        Property property = Property.fromDocument(document);

        properties.add(property);
      });
    });


    setState(() {
      loading = false;
    });

  }

  addNewProperty() async {
    //wait for user to add property
    await Navigator.pushNamed(context, "/addProperty");

    // load property from database

    print("===============1=================");

    await FirebaseFirestore.instance.collection('users')
        .doc(Provider.of<EKodi>(context, listen: false).account.userID)
        .collection('properties').orderBy("timestamp", descending: true).get().then((documents) {
          documents.docs.forEach((document) {
            Property property = Property.fromDocument(document);

            properties.add(property);
          });
    });

    setState(() {

    });

    print("===============2=================");

    print(properties.length);
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

  revenueOverview() {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        ListTile(
          title: const Text("Property Revenue Overview", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
          subtitle: Row(
          mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Show overview Jan 2022 - May 2022", style: TextStyle(fontSize: 13.0, color: Colors.grey, fontWeight: FontWeight.bold),),
              SizedBox(width: 5.0,),
              Text("Detailed Stats >", style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),),
            ],
          ),
          trailing: RaisedButton.icon(
            elevation: 0.0,
            hoverColor: Colors.transparent,
            color: Colors.deepPurple.shade100,
            icon: const Icon(Icons.cloud_download_outlined, color: Colors.deepPurple,),
            label: const Text("Download Report", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
            onPressed: () {},
          )
        ),
        SizedBox(
          height: 30.0,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 30.0,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2.0, color: Colors.black),
                          ),
                        ),
                      child: const Text("Overview", style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(width: 10.0,),
                    Container(
                        height: 30.0,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 2.0, color: Colors.transparent),
                          ),
                        ),
                      child: const Text("Leasing", style: TextStyle(fontSize: 13.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Week", style: TextStyle(fontSize: 13.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                    SizedBox(width: 10.0,),
                    Text("Month", style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),),
                    SizedBox(width: 10.0,),
                    Text("Year", style: TextStyle(fontSize: 13.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(height: 1, width: size.width,  color: Colors.grey,),
        Expanded(
          child: Row(
            children: [
              Expanded(
                //flex: 3,
                child:  SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(minimum: 0, maximum: 40, interval: 10),
                    tooltipBehavior: _tooltip,
                    series: <ChartSeries<_ChartData, String>>[
                      ColumnSeries<_ChartData, String>(
                          dataSource: data,
                          xValueMapper: (_ChartData data, _) => data.x,
                          yValueMapper: (_ChartData data, _) => data.y,
                          name: 'Gold',
                          color: Color.fromRGBO(8, 142, 255, 1))
                    ]),
              ),
              Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Container(
                        width: size.width*0.12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Kes 46,690", style: TextStyle(fontSize: 18.0, color: Colors.deepPurple, fontWeight: FontWeight.bold),),
                              const SizedBox(width: 20.0,),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text("Money in", style: TextStyle(fontSize: 11.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 5.0,),
                                  Icon(Icons.trending_up_rounded, color: Colors.teal,),
                                  Text("5.8%", style: TextStyle(fontSize: 11.0, color: Colors.teal, fontWeight: FontWeight.bold),),
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
                    child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Container(
                        width: size.width*0.12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(
                                color: Colors.grey,
                                width: 0.5
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Kes 8,940", style: TextStyle(fontSize: 18.0, color: Colors.orange, fontWeight: FontWeight.bold),),
                              const SizedBox(width: 20.0,),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text("Money out", style: TextStyle(fontSize: 11.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 5.0,),
                                  Icon(Icons.trending_down_rounded, color: Colors.red,),
                                  Text("26.4%", style: TextStyle(fontSize: 11.0, color: Colors.red, fontWeight: FontWeight.bold),),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  displayTab(Size size, SizingInformation sizeInfo) {
    bool isMobile = sizeInfo.isMobile;

    switch (selected) {
      case "Dashboard":
        return Column(
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 15.0, bottom: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: properties.isNotEmpty ? Colors.white : Colors.transparent,
                      boxShadow: properties.isNotEmpty ? [
                        const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 0.0)
                        )
                      ] : [],
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: properties.isNotEmpty ? 0.0 : 1.0,
                      )
                  ),
                  child: properties.isNotEmpty ? revenueOverview() : Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton.icon(
                          hoverColor: Colors.transparent,
                          label: const Text("New Property", style: TextStyle(color: Colors.deepPurple),),
                          color: Colors.deepPurple.shade100,
                          elevation: 0.0,
                          onPressed: addNewProperty,
                          icon: const Icon(Icons.add, color: Colors.deepPurple,),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Container(
                          width: size.width,
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
                          child: Column(
                            children: [
                              const ListTile(
                                title: Text('Recent Tasks', style: TextStyle(fontWeight: FontWeight.bold),),
                                trailing: Text('See all tasks', style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 2.0, color: Colors.deepPurple.shade900),
                                        ),
                                      ),
                                      child: const Center(child: Text("Incoming Requests", style: TextStyle(fontWeight: FontWeight.bold),),),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 30.0,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(width: 2.0, color: Colors.transparent),
                                        ),
                                      ),
                                      child: const Center(child: Text("Assigned to me", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0, left: 5.0),
                        child: Container(
                          width: size.width,
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
                          child: Column(
                            children: [
                              const ListTile(
                                title: Text('Expiring Leases', style: TextStyle(fontWeight: FontWeight.bold),),
                                trailing: Text('See details', style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
                              ),
                              Expanded(
                                child: Center(
                                  child: pie_chart.PieChart(
                                    dataMap: const {
                                      "<30 days": 8,
                                      "31-60 days": 16,
                                      "61-90 days": 22
                                    },
                                    animationDuration: const Duration(milliseconds: 800),
                                    chartLegendSpacing: 32,
                                    chartRadius: size.width*0.1,
                                    colorList: const [
                                      Colors.pink,
                                      Colors.orange,
                                      Colors.blueAccent
                                    ],
                                    initialAngleInDegree: 0,
                                    chartType: pie_chart.ChartType.ring,
                                    ringStrokeWidth: 15,
                                    centerText: "46 Properties",
                                    legendOptions: const pie_chart.LegendOptions(
                                      showLegendsInRow: true,
                                      legendPosition: pie_chart.LegendPosition.bottom,
                                      showLegends: true,
                                      //legendShape: _BoxShape.circle,
                                      legendTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey, fontSize: 15.0
                                      ),
                                    ),
                                    chartValuesOptions: const pie_chart.ChartValuesOptions(
                                      showChartValueBackground: true,
                                      showChartValues: true,
                                      showChartValuesInPercentage: false,
                                      showChartValuesOutside: true,
                                      decimalPlaces: 0,
                                    ),
                                    // gradientList: ---To add gradient colors---
                                    // emptyColorGradient: ---Empty Color gradient---
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      case "Accounting":
        return const Center(child: Text("Accounting"),);
      case "Reports":
        return const Center(child: Text("Reports"),);
      case "Messages":
        return const Center(child: Text("Messages"),);
      case "Tasks":
        return const Center(child: Text("Tasks"),);
      case "More":
        return const Center(child: Text("More"),);
    }
  }

  @override
  Widget build(BuildContext context) {
    Account account = context.watch<EKodi>().account;
    Size size = MediaQuery.of(context).size;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {
        bool isDesktop = sizeInfo.isDesktop;

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                child: RaisedButton.icon(
                  label: const Text("New Property", style: TextStyle(color: Colors.white),),
                  color: Colors.teal,
                  elevation: 0.0,
                  onPressed: addNewProperty,
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
          body:  loading ? Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
              child: Center(child: Image.asset("assets/loading.gif"),)) : Column(
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
                      SearchTextField(
                        controller: searchController,
                        hintText: "Search anything here...",
                      )
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.08),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: SizedBox(
                          width: size.width,
                          height: size.height,
                          child: displayTab(size, sizeInfo),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                width: size.width,
                                //height: 100.0,
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.apartment_rounded, size: 30.0, color: Colors.deepPurple.withOpacity(0.5),),
                                      title: const Text("98", style: TextStyle(fontWeight: FontWeight.bold),),
                                      subtitle: const Text("Properties", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),),
                                      trailing: const Text("See all properties >", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),),
                                    ),
                                    //const SizedBox(height: 10.0,),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          color: Colors.deepPurple.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: const [
                                                  Text("8", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                                  SizedBox(height: 5.0,),
                                                  Text("Vacant", style: TextStyle(fontSize: 15.0,  color: Colors.grey, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              const VerticalDivider(width: 1.0,),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: const [
                                                  Text("64", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                                  SizedBox(height: 5.0,),
                                                  Text("Occupied", style: TextStyle(fontSize: 15.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                              const VerticalDivider(width: 1.0,),
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: const [
                                                  Text("16", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                                  SizedBox(height: 5.0,),
                                                  Text("Unlisted", style: TextStyle(fontSize: 15.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text("Last 30 days", style: TextStyle(fontWeight: FontWeight.bold),),
                                        trailing: Icon(Icons.more_horiz, color: Colors.grey,),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              Text("Kes 36,840", style: TextStyle(fontSize: 18.0, color: Colors.teal, fontWeight: FontWeight.bold),),
                                              SizedBox(height: 5.0,),
                                              Text("paid invoices", style: TextStyle(fontSize: 15.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: const [
                                              Text("Kes 8,420", style: TextStyle(fontSize: 18.0, color: Colors.red, fontWeight: FontWeight.bold),),
                                              SizedBox(height: 5.0,),
                                              Text("open invoices", style: TextStyle(fontSize: 15.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          RaisedButton.icon(
                                            elevation: 0.0,
                                            hoverColor: Colors.transparent,
                                            color: Colors.deepPurple.shade100,
                                            icon: const Icon(Icons.paid_outlined, color: Colors.deepPurple,),
                                            label: const Text("Receive Payments", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                                            onPressed: () {},
                                          ),
                                          const Text("View All", style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: size.width,
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
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text("KES 6,280", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),),
                                      trailing: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.more_horiz, color: Colors.grey,),
                                      ),
                                    ),
                                    const ListTile(
                                      title: Text("Outstanding Balances", style: TextStyle(fontWeight: FontWeight.bold),),
                                      subtitle: Text("All properties", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                                      trailing: Icon(Icons.equalizer, color: Colors.teal, size: 30.0,),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
