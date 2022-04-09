import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
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
        ],
      ),
    );
  }
}
