import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/widgets/customTextField.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../config.dart';
import '../../model/account.dart';
import '../../providers/datePeriod.dart';


class _ChartData {
  _ChartData(this.x, this.y, this.y2);
  final String x;
  final double y;
  final double y2;
}

class TenantDash extends StatefulWidget {
  const TenantDash({Key? key}) : super(key: key);

  @override
  State<TenantDash> createState() => _TenantDashState();
}

class _TenantDashState extends State<TenantDash> {
  _TenantDashState();

  TextEditingController searchController = TextEditingController();
  List<_ChartData>? chartData;

  @override
  void initState() {
    chartData = <_ChartData>[
      _ChartData("Sept", 21, 5),
      _ChartData("Nov", 24, 7),
      _ChartData("Dec", 30, 15),
      _ChartData("Jan", 27, 30),
      _ChartData("Feb", 20, 25),
      _ChartData("March", 29, 24),
      _ChartData("April", 17, 27)
    ];
    super.initState();
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
        ),
        //const SizedBox(width: 10.0,),
        PopupMenuButton<String>(
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white,),
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

                Navigator.pushReplacementNamed(context, "/");
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
            start: args.value.startDate.millisecondsSinceEpoch, end: args.value.endDate.millisecondsSinceEpoch ?? DateTime.fromMillisecondsSinceEpoch(args.value.startDate.millisecondsSinceEpoch).subtract(const Duration(days: 30)) );
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
              selectionMode: DateRangePickerSelectionMode.range,
              initialSelectedRange: PickerDateRange(
                  DateTime.fromMillisecondsSinceEpoch(startDate),
                  DateTime.fromMillisecondsSinceEpoch(endDate)
              ),
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

  Widget displayPeriod(int? startDate, int? endDate) {
    String start = DateFormat("dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(startDate!));

    String end = DateFormat("dd MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(endDate!));

    return InkWell(
        onTap: () => displayCalendar(startDate, endDate),
        hoverColor: Colors.transparent,
        child: Text("$start - $end",  style: TextStyle(fontWeight: FontWeight.bold),));
  }

  /// Get the cartesian chart with default line series
  SfCartesianChart _buildDefaultLineChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: 'Billing Dates'),
      legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap),
      primaryXAxis: CategoryAxis(
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          //interval: 2,
          majorGridLines: const MajorGridLines(width: 0)),
      primaryYAxis: NumericAxis(
          maximum: 31,
          minimum: 0,
          interval: 5,
          labelFormat: '{value}th',
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(color: Colors.transparent)),
      series: _getDefaultLineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// The method returns line series to chart.
  List<LineSeries<_ChartData, dynamic>> _getDefaultLineSeries() {
    return <LineSeries<_ChartData, dynamic>>[
      LineSeries<_ChartData, dynamic>(
          animationDuration: 2500,
          dataSource: chartData!,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y,
          width: 2,
          name: 'Rent',
          markerSettings: const MarkerSettings(isVisible: true)),
      LineSeries<_ChartData, dynamic>(
          animationDuration: 2500,
          dataSource: chartData!,
          width: 2,
          name: 'Electricity',
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y2,
          markerSettings: const MarkerSettings(isVisible: true))
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Account account = context.watch<EKodi>().account;
    Size size = MediaQuery.of(context).size;
    int startDate = context.watch<DatePeriodProvider>().startDate;
    int endDate = context.watch<DatePeriodProvider>().endDate;

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
                Text("+254701518100", style: TextStyle(color: Colors.white, fontSize: 13.0),),
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
      body: Row(
        children: [
          Expanded(
            flex: 8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.05),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Dashboard", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                      SizedBox(
                        height: 80.0,
                        width: size.width*0.15,
                        child: AuthTextField(
                          controller: searchController,
                          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20.0,),
                          hintText: "Search here...",
                          inputType: TextInputType.text,
                          isObscure: false,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35.0),
                        child: account.photoUrl!  == ""
                            ? Image.asset("assets/profile.png", height: 70.0, width: 70.0, fit: BoxFit.cover,)
                            : Image.network(account.photoUrl!, height: 70.0, width: 70.0,fit: BoxFit.cover),
                      ),
                      Expanded(
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(
                              //style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(text: 'Hi, ', style: GoogleFonts.baloo2(fontSize: 20.0)),
                                TextSpan(text: account.name, style: GoogleFonts.baloo2(fontSize: 20.0, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          subtitle: Text("Welcome to e-KODI! Here's your activity today."),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1.0
                          )
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: const Text("Billing", style: TextStyle(fontWeight: FontWeight.bold,),),
                                    subtitle: displayPeriod(startDate, endDate),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildDefaultLineChart(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
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
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: size.width,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 2.0, color: Colors.grey.shade200),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SfDateRangePicker(
                      view: DateRangePickerView.month,
                      //onSelectionChanged: _onSelectionChanged,
                      enableMultiView: false,
                      selectionMode: DateRangePickerSelectionMode.single,
                      // initialSelectedRange: PickerDateRange(
                      //     DateTime.fromMillisecondsSinceEpoch(startDate),
                      //     DateTime.fromMillisecondsSinceEpoch(endDate)
                      // ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("Service Providers", style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.engineering_rounded, color: Colors.grey.shade300, size: 60.0,),
                          SizedBox(height: 10.0,),
                          Text("No service providers available", style: TextStyle(color: Colors.grey.shade300,),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
