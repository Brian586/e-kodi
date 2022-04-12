import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/config.dart';
import 'package:rekodi/pages/dashboards/landlordDash.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfLoggedIn();
  }

  void checkIfLoggedIn() async {
    if(EKodi().account.userID == null || EKodi().account.accountType == "") {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? accountType = context.watch<EKodi>().account.accountType!;

    return const LandlordDash();
  }
}
