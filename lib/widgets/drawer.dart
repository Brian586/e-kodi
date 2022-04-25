import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekodi/pages/authPage.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            onTap: () {},
            leading: Icon(
              Icons.home,
              color: Colors.grey,
            ),
            title: Text("Home", style: GoogleFonts.baloo2()),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.engineering_outlined,
              color: Colors.grey,
            ),
            title: Text("Services", style: GoogleFonts.baloo2()),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.live_help_outlined,
              color: Colors.grey,
            ),
            title: Text("Why Us", style: GoogleFonts.baloo2()),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.auto_awesome,
              color: Colors.grey,
            ),
            title: Text("Features", style: GoogleFonts.baloo2()),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.support_agent,
              color: Colors.grey,
            ),
            title: Text("Contact", style: GoogleFonts.baloo2()),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (context) => const AuthPage());
                Navigator.push(context, route);
              },
              color: Theme.of(context).primaryColor,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              child: Text("Log In",
                  style: GoogleFonts.baloo2(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}
