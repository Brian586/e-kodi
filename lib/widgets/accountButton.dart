import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/auth/auth.dart';
import 'package:rekodi/config.dart';
import 'package:rekodi/dialog/errorDialog.dart';
import 'package:rekodi/providers/loader.dart';

class AccountButton extends StatefulWidget {
  final String? title;
  final String? icon;
  final String? authType;
  final bool? isSignUp;
  final void Function()? onTap;

  const AccountButton({Key? key, this.title, this.icon, this.authType, this.isSignUp, this.onTap}) : super(key: key);

  @override
  State<AccountButton> createState() => _AccountButtonState();
}

class _AccountButtonState extends State<AccountButton> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: widget.onTap,
        hoverColor: Colors.transparent,
        child: Container(
          height: 60.0,
          width: size.width,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Image.asset(widget.icon!),
              ),
              const SizedBox(width: 10.0,),
              Text(widget.title!, maxLines: null, style: GoogleFonts.baloo2(color: Colors.black, fontSize: 18.0,)),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: //isHovered ? Theme.of(context).primaryColor :
            Colors.transparent,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 1.0
            )
          ),
        ),
      ),
    );
  }
}
