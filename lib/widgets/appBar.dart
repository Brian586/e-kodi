import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomAppBar extends StatelessWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const CustomAppBar({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizeInfo) {

        bool isDesktop = sizeInfo.isDesktop || sizeInfo.isTablet;

        return AppBar(
          title: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: 'e-', style: GoogleFonts.titanOne(color: Colors.blue, fontSize: 20.0)),
                TextSpan(text: 'KODI', style: GoogleFonts.titanOne(color: Colors.red, fontSize: 20.0)),
              ],
            ),
          ),
          backgroundColor: Colors.grey.shade200,
          automaticallyImplyLeading: false,
          elevation: 0.0,
          actions: isDesktop ? [
            TextButton(
              onPressed: () {},
              child: Text("Home", style: GoogleFonts.baloo2()),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Services", style: GoogleFonts.baloo2()),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Why Us", style: GoogleFonts.baloo2()),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Features", style: GoogleFonts.baloo2()),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Contact", style: GoogleFonts.baloo2()),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/auth');
                },
                color: Theme.of(context).primaryColor,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
                ),
                child: Text("Log In", style: GoogleFonts.baloo2(color: Colors.white)),
              ),
            )
          ] : [
             IconButton(
              onPressed: () => scaffoldKey!.currentState!.openDrawer(),
              icon: const Icon(Icons.menu, color: Colors.black,),
            )
          ],
        );
      },
    );
  }
}
