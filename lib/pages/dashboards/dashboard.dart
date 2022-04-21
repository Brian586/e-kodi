import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/config.dart';
import 'package:rekodi/pages/dashboards/landlordDash.dart';
import 'package:rekodi/pages/dashboards/serviceDash.dart';
import 'package:rekodi/pages/dashboards/tenantDash.dart';
import 'package:responsive_builder/responsive_builder.dart';


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

    switch (accountType) {
      case "Landlord":
        return ScreenTypeLayout.builder(
          mobile: (BuildContext context) => const LandlordDashMobile(),
          tablet: (BuildContext context) => const LandlordDashMobile(),
          desktop: (BuildContext context) => const LandlordDash(),
          watch: (BuildContext context) =>  Container(color: Colors.purple),
        );
      case "Tenant":
        return ScreenTypeLayout.builder(
          mobile: (BuildContext context) => const TenantDash(),
          tablet: (BuildContext context) => const TenantDash(),
          desktop: (BuildContext context) => const TenantDash(),
          watch: (BuildContext context) =>  Container(color: Colors.purple),
        );
      case "Service Provider":
        return ScreenTypeLayout.builder(
          mobile: (BuildContext context) => const ServiceDash(),
          tablet: (BuildContext context) => const ServiceDash(),
          desktop: (BuildContext context) => const ServiceDash(),
          watch: (BuildContext context) =>  Container(color: Colors.purple),
        );
      default:
        return TenantDash();
    }


  }
}
