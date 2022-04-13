import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/model/tabItem.dart';
import 'package:rekodi/widgets/customTextField.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../config.dart';
import '../../model/account.dart';


class LandlordDash extends StatefulWidget {
  const LandlordDash({Key? key}) : super(key: key);

  @override
  State<LandlordDash> createState() => _LandlordDashState();
}

class _LandlordDashState extends State<LandlordDash> {
  String selected = 'Dashboard';
  TextEditingController searchController = TextEditingController();

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
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      )
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton.icon(
                          hoverColor: Colors.transparent,
                          label: const Text("New Property", style: TextStyle(color: Colors.deepPurple),),
                          color: Colors.deepPurple.shade100,
                          elevation: 0.0,
                          onPressed: () {},
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
                                      decoration: BoxDecoration(
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
                                  child: PieChart(
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
                                    chartType: ChartType.ring,
                                    ringStrokeWidth: 15,
                                    centerText: "46 Properties",
                                    legendOptions: const LegendOptions(
                                      showLegendsInRow: true,
                                      legendPosition: LegendPosition.bottom,
                                      showLegends: true,
                                      //legendShape: _BoxShape.circle,
                                      legendTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey, fontSize: 15.0
                                      ),
                                    ),
                                    chartValuesOptions: const ChartValuesOptions(
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
