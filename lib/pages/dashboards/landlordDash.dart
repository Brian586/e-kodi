import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart' as pie_chart;
import 'package:provider/provider.dart';
import 'package:rekodi/chat/chatBuilder.dart';
import 'package:rekodi/chat/chatHome.dart';
import 'package:rekodi/chat/chatProvider/chatProvider.dart';
import 'package:rekodi/main.dart';
import 'package:rekodi/model/property.dart';
import 'package:rekodi/model/tabItem.dart';
import 'package:rekodi/pages/addProperty.dart';
import 'package:rekodi/pages/propertyDetails.dart';
import 'package:rekodi/providers/datePeriod.dart';
import 'package:rekodi/widgets/customTextField.dart';
import 'package:rekodi/widgets/loadingAnimation.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../config.dart';
import '../../model/account.dart';
import '../../model/unit.dart';

class _ChartData {
  _ChartData({this.x, this.y1, this.y2});

  final String? x;
  final double? y2;
  final double? y1;
}

class LandlordDash extends StatefulWidget {
  const LandlordDash({Key? key}) : super(key: key);

  @override
  State<LandlordDash> createState() => _LandlordDashState();
}

class _LandlordDashState extends State<LandlordDash> {
  _LandlordDashState();
  String selected = 'Dashboard';
  TextEditingController searchController = TextEditingController();
  List<Property> properties = [];
  int vacantUnits = 0;
  int occupiedUnits = 0;
  bool loading = false;
  List<_ChartData>? chartData;
  TooltipBehavior? _tooltipBehavior;
  final double _columnWidth = 0.8;
  final double _columnSpacing = 0.2;
  //List<Unit> allUnits = [];

  @override
  void initState() {
    super.initState();

    chartData = [
      _ChartData(x: 'Dec', y1: 12, y2: 15),
      _ChartData(x: 'Jan', y1: 15, y2: 11),
      _ChartData(x: 'Feb', y1: 30, y2: 20),
      _ChartData(x: 'March', y1: 6.4, y2: 10),
      _ChartData(x: 'April', y1: 14, y2: 5),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);

    getUserInfo();
  }

  void getUserInfo() async {
    setState(() {
      loading = true;
    });

    vacantUnits = 0;
    occupiedUnits = 0;

    String userID = Provider.of<EKodi>(context, listen: false).account.userID!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .get()
        .then((value) async {
      await context.read<EKodi>().switchUser(Account.fromDocument(value));
    });

    await FirebaseFirestore.instance
        .collection('properties')
        .where("publisherID", isEqualTo: userID)
        .orderBy("timestamp", descending: true)
        .get()
        .then((documents) {
      documents.docs.forEach((document) async {
        Property property = Property.fromDocument(document);

        properties.add(property);

        vacantUnits = vacantUnits + property.vacant!.toInt();

        occupiedUnits = occupiedUnits + property.occupied!.toInt();
      });
    });

    setState(() {
      loading = false;
    });
  }

  addNewProperty() async {
    //wait for user to add property
    Route route = MaterialPageRoute(builder: (context) => const AddProperty());
    String res = await Navigator.push(context, route);

    if(res == "uploaded") {
      setState(() {
        vacantUnits = 0;
        occupiedUnits = 0;
        properties.clear();
      });

      String userID = Provider.of<EKodi>(context, listen: false).account.userID!;

      // load property from database

      await FirebaseFirestore.instance
          .collection('properties')
          .where("publisherID", isEqualTo: userID)
          .orderBy("timestamp", descending: true)
          .get()
          .then((documents) {
        documents.docs.forEach((document) async {
          Property property = Property.fromDocument(document);

          properties.add(property);

          setState(() {
            vacantUnits = vacantUnits + property.vacant!.toInt();

            occupiedUnits = occupiedUnits + property.occupied!.toInt();
          });
        });
      });

    }
    setState(() {});
  }

  displayUserProfile(Account account) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: account.photoUrl! == ""
              ? Image.asset(
                  "assets/profile.png",
                  height: 36.0,
                  width: 36.0,
                )
              : Image.network(
                  account.photoUrl!,
                  height: 36.0,
                  width: 36.0,
                ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account.name!,
              style: const TextStyle(color: Colors.white, fontSize: 13.0),
            ),
            Text(
              account.accountType!,
              style: const TextStyle(color: Colors.white30, fontSize: 11.0),
            )
          ],
        ),
        //const SizedBox(width: 10.0,),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          offset: const Offset(0.0, 0.0),
          onSelected: (v) async {
            switch (v) {
              case "My Account":
                //Go to account page
                break;
              case "Settings":
                //Go to settings page
                break;
              case "Logout":
                //Logout user
                await FirebaseAuth.instance.signOut();

                Route route = MaterialPageRoute(
                    builder: (context) => const SplashScreen());

                Navigator.pushReplacement(context, route);
            }
          },
          itemBuilder: (BuildContext context) {
            return ["My Account", "Settings", "Logout"].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  //Get the cartesian chart widget
  SfCartesianChart _buildSpacingColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      // title: ChartTitle(
      //     text: isCardView ? '' : 'Winter olympic medals count - 2022'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          maximum: 50,
          minimum: 0,
          interval: 5,
          labelFormat: '{value}k',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumn(),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  //Get the column series
  List<ColumnSeries<_ChartData, String>> _getDefaultColumn() {
    return <ColumnSeries<_ChartData, String>>[
      ColumnSeries<_ChartData, String>(

          // To apply the column width here.
          width: _columnWidth,

          // To apply the spacing betweeen to two columns here.
          spacing: _columnSpacing,
          dataSource: chartData!,
          color: Colors.orange,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y1,
          name: 'Expense'),
      ColumnSeries<_ChartData, String>(
          dataSource: chartData!,
          width: _columnWidth,
          spacing: _columnSpacing,
          color: Colors.deepPurple,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y2,
          name: 'Income'),
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  revenueOverview({int? startDate, int? endDate}) {
    Size size = MediaQuery.of(context).size;

    String start = DateFormat("dd MMM yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(startDate!));

    String end = DateFormat("dd MMM yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(endDate!));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            title: const Text(
              "Property Revenue Overview",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$start - $end",
                  style: const TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                const Text(
                  "Detailed Stats >",
                  style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            trailing: RaisedButton.icon(
              elevation: 0.0,
              hoverColor: Colors.transparent,
              color: Colors.deepPurple.shade100,
              icon: const Icon(
                Icons.cloud_download_outlined,
                color: Colors.deepPurple,
              ),
              label: const Text("Download Report",
                  style: TextStyle(
                      color: Colors.deepPurple, fontWeight: FontWeight.bold)),
              onPressed: () {},
            )),
        SizedBox(
          height: 30.0,
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 30.0,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2.0, color: Colors.black),
                        ),
                      ),
                      child: const Text(
                        "Overview",
                        style: TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      height: 30.0,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(width: 2.0, color: Colors.transparent),
                        ),
                      ),
                      child: const Text(
                        "Leasing",
                        style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text(
                      "Week",
                      style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Month",
                      style: TextStyle(
                          fontSize: 13.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      "Year",
                      style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey.shade400,
          height: 0.5,
          thickness: 0.5,
        ),
        Row(
          children: [
            Expanded(
              //flex: 3,
              child: _buildSpacingColumnChart(),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Container(
                    width: size.width * 0.12,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey, width: 0.5)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Kes 46,690",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "Money in",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.trending_up_rounded,
                                color: Colors.teal,
                              ),
                              Text(
                                "5.8%",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Container(
                    width: size.width * 0.12,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey, width: 0.5)),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Kes 8,940",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "Money out",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Icon(
                                Icons.trending_down_rounded,
                                color: Colors.red,
                              ),
                              Text(
                                "26.4%",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  displayTab(Size size, SizingInformation sizeInfo, {int? start, int? end}) {
    switch (selected) {
      case "Dashboard":
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, right: 15.0, bottom: 5.0),
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: properties.isNotEmpty
                        ? Colors.white
                        : Colors.transparent,
                    boxShadow: properties.isNotEmpty
                        ? [
                            const BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1,
                                spreadRadius: 1.0,
                                offset: Offset(0.0, 0.0))
                          ]
                        : [],
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: properties.isNotEmpty ? 0.0 : 1.0,
                    )),
                child: properties.isNotEmpty
                    ? revenueOverview(startDate: start, endDate: end)
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton.icon(
                                hoverColor: Colors.transparent,
                                label: const Text(
                                  "New Property",
                                  style: TextStyle(color: Colors.deepPurple),
                                ),
                                color: Colors.deepPurple.shade100,
                                elevation: 0.0,
                                onPressed: addNewProperty,
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  offset: Offset(0.0, 0.0))
                            ],
                            border: Border.all(
                                width: 0.5, color: Colors.grey.shade300)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ListTile(
                              title: Text(
                                'Recent Transactions',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                'See all',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              color: Colors.grey.shade300,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.currency_exchange_rounded,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(
                                      height: 5.0,
                                    ),
                                    Text("No transactions")
                                  ],
                                ),
                              ),
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
                                  offset: Offset(0.0, 0.0))
                            ],
                            border: Border.all(
                                width: 0.5, color: Colors.grey.shade300)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const ListTile(
                              title: Text(
                                'Expiring Leases',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              trailing: Text(
                                'See details',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: pie_chart.PieChart(
                                dataMap: const {
                                  "<30 days": 8,
                                  "31-60 days": 16,
                                  "61-90 days": 22
                                },
                                animationDuration:
                                    const Duration(milliseconds: 800),
                                chartLegendSpacing: 32,
                                chartRadius: size.width * 0.1,
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
                                  legendPosition:
                                      pie_chart.LegendPosition.bottom,
                                  showLegends: true,
                                  //legendShape: _BoxShape.circle,
                                  legendTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 15.0),
                                ),
                                chartValuesOptions:
                                    const pie_chart.ChartValuesOptions(
                                  showChartValueBackground: true,
                                  showChartValues: true,
                                  showChartValuesInPercentage: false,
                                  showChartValuesOutside: true,
                                  decimalPlaces: 0,
                                ),
                                // gradientList: ---To add gradient colors---
                                // emptyColorGradient: ---Empty Color gradient---
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      case "Accounting":
        return const Center(
          child: Text("Accounting"),
        );
      case "Reports":
        return const Center(
          child: Text("Reports"),
        );
      case "Messages":
        return const Padding(
          padding: EdgeInsets.only(right: 15.0, top: 10.0),
          child: ChatBuilder(),
        );
      case "Tasks":
        return const Center(
          child: Text("Tasks"),
        );
    }
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
      if (args.value is PickerDateRange) {
        // String _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // // ignore: lines_longer_than_80_chars
        //     ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';

        context.read<DatePeriodProvider>().updatePeriod(
            start: args.value.startDate.millisecondsSinceEpoch,
            end: args.value.endDate.millisecondsSinceEpoch ??
                DateTime.fromMillisecondsSinceEpoch(
                        args.value.startDate.millisecondsSinceEpoch)
                    .subtract(const Duration(days: 30)));
      }
      // else if (args.value is DateTime) {
      //   _selectedDate = args.value.toString();
      // } else if (args.value is List<DateTime>) {
      //   _dateCount = args.value.length.toString();
      // } else {
      //   _rangeCount = args.value.length.toString();
      // }
    });
  }

  displayProperties(Account account) {
    Size size = MediaQuery.of(context).size;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("My Properties"),
              Divider(
                color: Colors.grey.shade300,
              )
            ],
          ),
          content: Container(
            height: size.height * 0.6,
            width: size.width * 0.4,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("properties")
                  .where("publisherID", isEqualTo: account.userID)
                  .orderBy("timestamp", descending: true)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LoadingAnimation();
                } else {
                  List<Property> properties = [];

                  snapshot.data!.docs.forEach((element) {
                    properties.add(Property.fromDocument(element));
                  });

                  if (properties.isEmpty) {
                    return const Center(
                      child: Text(
                        "You don't have properties",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: properties.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Property property = properties[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: InkWell(
                            onTap: () {
                              Route route = MaterialPageRoute(builder: (context)=> PropertyDetails(property));
                              Navigator.push(context, route);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.house_rounded,
                                  color: Colors.grey,
                                  size: 30.0,
                                ),
                                title: Text(
                                  property.name!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Published on " +
                                          DateFormat("dd MMM").format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  property.timestamp!)),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text("Units: ${property.units}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(property.vacant!.toString()),
                                          Text("Vacant")
                                        ]),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(property.occupied!.toString()),
                                          Text("Occupied")
                                        ])
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
        );
      },
    );
  }

  displayCalendar(int startDate, int endDate) {
    Size size = MediaQuery.of(context).size;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Pick range"),
          content: Container(
            height: size.height * 0.6,
            width: size.width * 0.4,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            child: SfDateRangePicker(
              view: DateRangePickerView.month,
              onSelectionChanged: _onSelectionChanged,
              enableMultiView: true,
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                  DateTime.fromMillisecondsSinceEpoch(startDate),
                  DateTime.fromMillisecondsSinceEpoch(endDate)),
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.done, color: Theme.of(context).primaryColor),
              label: Text(
                "Done",
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            )
          ],
        );
      },
    );
  }

  Widget dateSelector({int? startDate, int? endDate}) {
    String start = DateFormat("dd MMM yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(startDate!));

    String end = DateFormat("dd MMM yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(endDate!));

    return InkWell(
      onTap: () => displayCalendar(startDate, endDate),
      child: Container(
        height: 30.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.0),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 0.0))
            ],
            border: Border.all(width: 0.5, color: Colors.grey.shade300)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.date_range_rounded,
                color: Colors.grey,
                size: 15.0,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                "$start - $end",
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13.0,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 5.0,
              ),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Account account = context.watch<EKodi>().account;
    int startDate = context.watch<DatePeriodProvider>().startDate;
    int endDate = context.watch<DatePeriodProvider>().endDate;

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
                      TextSpan(
                          text: 'e-',
                          style: GoogleFonts.titanOne(
                              color: Colors.blue, fontSize: 20.0)),
                      TextSpan(
                          text: 'KODI',
                          style: GoogleFonts.titanOne(
                              color: Colors.red, fontSize: 20.0)),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                const VerticalDivider(
                  color: Colors.grey,
                ),
                Icon(
                  Icons.phone,
                  color: Colors.blueAccent.shade700,
                  size: 15.0,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "+254701518100",
                      style: TextStyle(color: Colors.white, fontSize: 13.0),
                    ),
                    Text(
                      "Help & Support",
                      style: TextStyle(color: Colors.white30, fontSize: 11.0),
                    ),
                  ],
                )
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 15.0),
                child: RaisedButton.icon(
                  label: const Text(
                    "New Property",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.teal,
                  elevation: 0.0,
                  onPressed: addNewProperty,
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_active_rounded,
                  color: Colors.white30,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.question_answer_outlined,
                  color: Colors.white30,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              displayUserProfile(account),
              const SizedBox(
                width: 20.0,
              ),
            ],
          ),
          body: loading
              ? const LoadingAnimation()
              : Column(
                  //mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: size.width,
                      height: 40.0,
                      decoration:
                          const BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 0.0),
                            spreadRadius: 2.0,
                            blurRadius: 2.0)
                      ]),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.08),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: InkWell(
                                    onTap: () {

                                      setState(() {
                                        selected = item.name!;
                                        context.read<ChatProvider>().openChatDetails(false);
                                      });
                                    },
                                    child: Container(
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 2.0,
                                              color: isSelected
                                                  ? Colors.deepPurple.shade900
                                                  : Colors.transparent),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            item.iconData!,
                                            color: isSelected
                                                ? Colors.deepPurple.shade900
                                                : Colors.grey,
                                            size: 15.0,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            item.name!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .apply(
                                                    color: isSelected
                                                        ? Colors
                                                            .deepPurple.shade900
                                                        : Colors.grey,
                                                    fontWeightDelta: 2),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),

                            //TODO: Put search widget here
                            // SizedBox(
                            //   height: 40.0,
                            //   child: AuthTextField(
                            //     controller: searchController,
                            //     prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            //     hintText: "Search anything here...",
                            //     isObscure: false,
                            //     inputType: TextInputType.text,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: size.width,
                              height: 60.0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.08),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          selected,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .apply(
                                                  color: Colors.black,
                                                  fontWeightDelta: 10),
                                        ),
                                        Text(
                                          "Hi ${account.name!}, Welcome to e-Ekodi",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    dateSelector(
                                        startDate: startDate, endDate: endDate)
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.08),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 7,
                                    child: displayTab(size, sizeInfo,
                                        start: startDate, end: endDate),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Container(
                                            width: size.width,
                                            //height: 100.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 1,
                                                      spreadRadius: 1.0,
                                                      offset: Offset(0.0, 0.0))
                                                ],
                                                border: Border.all(
                                                    width: 0.5,
                                                    color:
                                                        Colors.grey.shade300)),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                    leading: Icon(
                                                      Icons.apartment_rounded,
                                                      size: 30.0,
                                                      color: Colors.deepPurple
                                                          .withOpacity(0.5),
                                                    ),
                                                    title: Text(
                                                      properties.length
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: const Text(
                                                      "Properties",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey),
                                                    ),
                                                    trailing: TextButton(
                                                      onPressed: () =>
                                                          displayProperties(
                                                              account),
                                                      child: const Text(
                                                        "See all properties >",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .deepPurple),
                                                      ),
                                                    )),
                                                //const SizedBox(height: 10.0,),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Container(
                                                    width: size.width,
                                                    decoration: BoxDecoration(
                                                      color: Colors.deepPurple
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                vacantUnits
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              const SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              const Text(
                                                                "Vacant",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          const VerticalDivider(
                                                            width: 1.0,
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                occupiedUnits
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        18.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              const SizedBox(
                                                                height: 5.0,
                                                              ),
                                                              const Text(
                                                                "Occupied",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: Colors
                                                                        .grey,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                          // const VerticalDivider(width: 1.0,),
                                                          // Column(
                                                          //   mainAxisSize: MainAxisSize.min,
                                                          //   crossAxisAlignment: CrossAxisAlignment.center,
                                                          //   children: const [
                                                          //     Text("16", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                                                          //     SizedBox(height: 5.0,),
                                                          //     Text("Unlisted", style: TextStyle(fontSize: 15.0, color: Colors.grey, fontWeight: FontWeight.bold),),
                                                          //   ],
                                                          // ),
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 1,
                                                      spreadRadius: 1.0,
                                                      offset: Offset(0.0, 0.0))
                                                ],
                                                border: Border.all(
                                                    width: 0.5,
                                                    color:
                                                        Colors.grey.shade300)),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.all(15.0),
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    title: Text(
                                                      "Last 30 days",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    trailing: Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Text(
                                                            "Kes 36,840",
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                color:
                                                                    Colors.teal,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(
                                                            "paid invoices",
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Text(
                                                            "Kes 8,420",
                                                            style: TextStyle(
                                                                fontSize: 18.0,
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(
                                                            height: 5.0,
                                                          ),
                                                          Text(
                                                            "open invoices",
                                                            style: TextStyle(
                                                                fontSize: 15.0,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      RaisedButton.icon(
                                                        elevation: 0.0,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        color: Colors.deepPurple
                                                            .shade100,
                                                        icon: const Icon(
                                                          Icons.paid_outlined,
                                                          color:
                                                              Colors.deepPurple,
                                                        ),
                                                        label: const Text(
                                                            "Receive Payments",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .deepPurple,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        onPressed: () {},
                                                      ),
                                                      const Text("View All",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .deepPurple,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3.0),
                                              color: Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 1,
                                                    spreadRadius: 1.0,
                                                    offset: Offset(0.0, 0.0))
                                              ],
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.grey.shade300)),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  "KES 6,280",
                                                  style: TextStyle(
                                                      fontSize: 25.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                trailing: IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    Icons.more_horiz,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              const ListTile(
                                                title: Text(
                                                  "Outstanding Balances",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                subtitle: Text(
                                                  "All properties",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                trailing: Icon(
                                                  Icons.equalizer,
                                                  color: Colors.teal,
                                                  size: 30.0,
                                                ),
                                              ),
                                            ],
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
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}

class LandlordDashMobile extends StatefulWidget {
  const LandlordDashMobile({Key? key}) : super(key: key);

  @override
  State<LandlordDashMobile> createState() => _LandlordDashMobileState();
}

class _LandlordDashMobileState extends State<LandlordDashMobile> {
  _LandlordDashMobileState();
  String selected = 'Dashboard';
  TextEditingController searchController = TextEditingController();
  List<Property> properties = [];
  bool loading = false;
  List<_ChartData>? chartData;
  TooltipBehavior? _tooltipBehavior;
  final double _columnWidth = 0.8;
  final double _columnSpacing = 0.2;

  @override
  void initState() {
    super.initState();

    chartData = [
      _ChartData(x: 'Dec', y1: 12, y2: 15),
      _ChartData(x: 'Jan', y1: 15, y2: 11),
      _ChartData(x: 'Feb', y1: 30, y2: 20),
      _ChartData(x: 'March', y1: 6.4, y2: 10),
      _ChartData(x: 'April', y1: 14, y2: 5),
    ];
    _tooltipBehavior = TooltipBehavior(enable: true);

    getUserInfo();
  }

  void getUserInfo() async {
    setState(() {
      loading = true;
    });

    String userID = Provider.of<EKodi>(context, listen: false).account.userID!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userID)
        .get()
        .then((value) async {
      await context.read<EKodi>().switchUser(Account.fromDocument(value));
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('properties')
        .orderBy("timestamp", descending: true)
        .get()
        .then((documents) {
      documents.docs.forEach((document) {
        Property property = Property.fromDocument(document);

        properties.add(property);
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
          child: account.photoUrl! == ""
              ? Image.asset(
                  "assets/profile.png",
                  height: 36.0,
                  width: 36.0,
                )
              : Image.network(
                  account.photoUrl!,
                  height: 36.0,
                  width: 36.0,
                ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account.name!,
              style: const TextStyle(color: Colors.white, fontSize: 13.0),
            ),
            Text(
              account.accountType!,
              style: const TextStyle(color: Colors.white30, fontSize: 11.0),
            )
          ],
        ),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          offset: const Offset(0.0, 0.0),
          onSelected: (v) async {
            switch (v) {
              case "My Account":
                //Go to account page
                break;
              case "Settings":
                //Go to settings page
                break;
              case "Logout":
                //Logout user
                await FirebaseAuth.instance.signOut();

                Route route = MaterialPageRoute(
                    builder: (context) => const SplashScreen());

                Navigator.pushReplacement(context, route);
            }
          },
          itemBuilder: (BuildContext context) {
            return ["My Account", "Settings", "Logout"].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  addNewProperty() async {
    //wait for user to add property
    Route route = MaterialPageRoute(builder: (context) => const AddProperty());
    await Navigator.push(context, route);

    // load property from database

    await FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<EKodi>(context, listen: false).account.userID)
        .collection('properties')
        .orderBy("timestamp", descending: true)
        .get()
        .then((documents) {
      documents.docs.forEach((document) {
        Property property = Property.fromDocument(document);

        properties.add(property);
      });
    });

    setState(() {});
  }

  //Get the cartesian chart widget
  SfCartesianChart _buildSpacingColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      // title: ChartTitle(
      //     text: isCardView ? '' : 'Winter olympic medals count - 2022'),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          maximum: 50,
          minimum: 0,
          interval: 5,
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getDefaultColumn(),
      legend: Legend(isVisible: true),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  //Get the column series
  List<ColumnSeries<_ChartData, String>> _getDefaultColumn() {
    return <ColumnSeries<_ChartData, String>>[
      ColumnSeries<_ChartData, String>(

          // To apply the column width here.
          width: _columnWidth,

          // To apply the spacing betweeen to two columns here.
          spacing: _columnSpacing,
          dataSource: chartData!,
          color: Colors.orange,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y1,
          name: 'Expense'),
      ColumnSeries<_ChartData, String>(
          dataSource: chartData!,
          width: _columnWidth,
          spacing: _columnSpacing,
          color: Colors.deepPurple,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y2,
          name: 'Income'),
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  displayTabs(Size size) {
    switch (selected) {
      case "Dashboard":
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  height: 30.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 0.0))
                      ],
                      border:
                          Border.all(width: 0.5, color: Colors.grey.shade300)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.date_range_rounded,
                          color: Colors.grey,
                          size: 15.0,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Jan 2022 - Apr 2022",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
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
                            blurRadius: 2.0)
                      ]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                          title: const Text(
                            "Property Revenue Overview",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                "Jan 2022 - May 2022",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "Detailed Stats >",
                                style: TextStyle(
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.cloud_download_outlined,
                              color: Colors.deepPurple,
                            ),
                          )),
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
                                        bottom: BorderSide(
                                            width: 2.0, color: Colors.black),
                                      ),
                                    ),
                                    child: const Text(
                                      "Overview",
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    height: 30.0,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 2.0,
                                            color: Colors.transparent),
                                      ),
                                    ),
                                    child: const Text(
                                      "Leasing",
                                      style: TextStyle(
                                          fontSize: 13.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    "Week",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    "Month",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    "Year",
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        width: size.width,
                        color: Colors.grey,
                      ),
                      _buildSpacingColumnChart(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10.0),
                            child: Container(
                              width: size.width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Kes 46,690",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          "Money in",
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Icon(
                                          Icons.trending_up_rounded,
                                          color: Colors.teal,
                                        ),
                                        Text(
                                          "5.8%",
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5.0, vertical: 10.0),
                            child: Container(
                              width: size.width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5)),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Kes 8,940",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          "Money out",
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Icon(
                                          Icons.trending_down_rounded,
                                          color: Colors.red,
                                        ),
                                        Text(
                                          "26.4%",
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 0.0))
                      ],
                      border:
                          Border.all(width: 0.5, color: Colors.grey.shade300)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ListTile(
                        title: Text(
                          'Expiring Leases',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          'See details',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: pie_chart.PieChart(
                          dataMap: const {
                            "<30 days": 8,
                            "31-60 days": 16,
                            "61-90 days": 22
                          },
                          animationDuration: const Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: size.width * 0.4,
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
                                color: Colors.grey,
                                fontSize: 15.0),
                          ),
                          chartValuesOptions:
                              const pie_chart.ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: true,
                            decimalPlaces: 0,
                          ),
                          // gradientList: ---To add gradient colors---
                          // emptyColorGradient: ---Empty Color gradient---
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Container(
                  width: size.width,
                  //height: 100.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 0.0))
                      ],
                      border:
                          Border.all(width: 0.5, color: Colors.grey.shade300)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                          leading: Icon(
                            Icons.apartment_rounded,
                            size: 30.0,
                            color: Colors.deepPurple.withOpacity(0.5),
                          ),
                          title: const Text(
                            "98",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                            "Properties",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          trailing: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/properties");
                            },
                            child: const Text(
                              "See all properties >",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple),
                            ),
                          )),
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
                                    Text(
                                      "8",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Vacant",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const VerticalDivider(
                                  width: 1.0,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "64",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Occupied",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const VerticalDivider(
                                  width: 1.0,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "16",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      "Unlisted",
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold),
                                    ),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 0.0))
                      ],
                      border:
                          Border.all(width: 0.5, color: Colors.grey.shade300)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            "Last 30 days",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                          ),
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
                                Text(
                                  "Kes 36,840",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "paid invoices",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Kes 8,420",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  "open invoices",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                ),
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
                              icon: const Icon(
                                Icons.paid_outlined,
                                color: Colors.deepPurple,
                              ),
                              label: const Text("Receive Payments",
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {},
                            ),
                            const Text("View All",
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 0.0))
                      ],
                      border:
                          Border.all(width: 0.5, color: Colors.grey.shade300)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ListTile(
                        title: Text(
                          'Recent Transactions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          'See all',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(
                        height: 1.0,
                        color: Colors.grey,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.currency_exchange_rounded,
                                  color: Colors.grey),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                "No transactions yet",
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1,
                            spreadRadius: 1.0,
                            offset: Offset(0.0, 0.0))
                      ],
                      border:
                          Border.all(width: 0.5, color: Colors.grey.shade300)),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "KES 6,280",
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_horiz,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      const ListTile(
                        title: Text(
                          "Outstanding Balances",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "All properties",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.equalizer,
                          color: Colors.teal,
                          size: 30.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      case "Accounting":
        return const Center(
          child: Text("Accounting"),
        );
      case "Reports":
        return const Center(
          child: Text("Reports"),
        );
      case "Messages":
        return const Center(
          child: Text("Messages"),
        );
      case "Tasks":
        return const Center(
          child: Text("Tasks"),
        );
      case "More":
        return const Center(
          child: Text("More"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    Account account = context.watch<EKodi>().account;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: RichText(
                  text: TextSpan(
                    //style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: 'e-',
                          style: GoogleFonts.titanOne(
                              color: Colors.blue, fontSize: 20.0)),
                      TextSpan(
                          text: 'KODI',
                          style: GoogleFonts.titanOne(
                              color: Colors.red, fontSize: 20.0)),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  selected = "Dashboard";
                });
              },
              leading: Icon(
                Icons.dashboard,
                color:
                    selected == "Dashboard" ? Colors.deepPurple : Colors.grey,
              ),
              title: Text(
                "Dashboard",
                style: TextStyle(
                  color:
                      selected == "Dashboard" ? Colors.deepPurple : Colors.grey,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  selected = "Accounting";
                });
              },
              leading: Icon(
                Icons.paid_outlined,
                color:
                    selected == "Accounting" ? Colors.deepPurple : Colors.grey,
              ),
              title: Text(
                "Accounting",
                style: TextStyle(
                  color: selected == "Accounting"
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  selected = "Reports";
                });
              },
              leading: Icon(
                Icons.receipt_long_outlined,
                color: selected == "Reports" ? Colors.deepPurple : Colors.grey,
              ),
              title: Text(
                "Reports",
                style: TextStyle(
                  color:
                      selected == "Reports" ? Colors.deepPurple : Colors.grey,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  selected = "Messages";
                });
              },
              leading: Icon(
                Icons.question_answer_outlined,
                color: selected == "Messages" ? Colors.deepPurple : Colors.grey,
              ),
              title: Text(
                "Messages",
                style: TextStyle(
                  color:
                      selected == "Messages" ? Colors.deepPurple : Colors.grey,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  selected = "Tasks";
                });
              },
              leading: Icon(
                Icons.check_box_outlined,
                color: selected == "Tasks" ? Colors.deepPurple : Colors.grey,
              ),
              title: Text(
                "Tasks",
                style: TextStyle(
                  color: selected == "Tasks" ? Colors.deepPurple : Colors.grey,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  selected = "Settings";
                });
              },
              leading: Icon(
                Icons.settings,
                color: selected == "Settings" ? Colors.deepPurple : Colors.grey,
              ),
              title: Text(
                "Settings",
                style: TextStyle(
                  color:
                      selected == "Settings" ? Colors.deepPurple : Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: addNewProperty,
        backgroundColor: Colors.teal,
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        //automaticallyImplyLeading: false,
        elevation: 0.0,
        title: RichText(
          text: TextSpan(
            //style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: 'e-',
                  style:
                      GoogleFonts.titanOne(color: Colors.blue, fontSize: 20.0)),
              TextSpan(
                  text: 'KODI',
                  style:
                      GoogleFonts.titanOne(color: Colors.red, fontSize: 20.0)),
            ],
          ),
        ),
        actions: [
          displayUserProfile(account),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: loading
          ? Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
              child: Center(
                child: Image.asset("assets/loading.gif"),
              ))
          : displayTabs(size),
    );
  }
}
