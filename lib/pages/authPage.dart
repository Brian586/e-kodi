import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/config.dart';
import 'package:rekodi/model/account.dart';
import 'package:rekodi/providers/loader.dart';
import 'package:rekodi/widgets/accountButton.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../auth/auth.dart';
import '../dialog/errorDialog.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isSignUp = false;

  double getWidth(Size size, SizingInformation sizeInfo) {
    if(sizeInfo.isMobile)
      {
        return 20.0;
      }
    else if(sizeInfo.isTablet)
    {
      return size.width*0.2;
    }
    else
    {
      return size.width*0.3;
    }
  }

  void handleAuth(String? authType) async {
    String res = await Authentication().performAuthentication(context, authType!, isSignUp);

    await context.read<Loader>().switchLoadingState(false);

    if(res.split("+").first == "success")
    {
      await FirebaseFirestore.instance.collection("users").doc(res.split("+").last).get().then((value) {
        Account account = Account.fromDocument(value);

        context.read<EKodi>().switchUser(account);
      });

      if(isSignUp)
        {
          await Navigator.pushNamed(context, "/selectAccount");
        }

      Navigator.pushReplacementNamed(context, "/dashboard");
    }
    else {
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        // false = user must tap button, true = tap outside dialog
        builder: (BuildContext dialogContext) {
          return ErrorAlertDialog(message: "Error: $res",);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool loading = context.watch<Loader>().loading;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {

        bool isMobile = sizeInfo.isMobile;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.grey,),
            ),
            title: RichText(
              text: TextSpan(
                //style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(text: 'e-', style: GoogleFonts.titanOne(color: Colors.blue, fontSize: 20.0)),
                  TextSpan(text: 'KODI', style: GoogleFonts.titanOne(color: Colors.red, fontSize: 20.0)),
                ],
              ),
            ),
            backgroundColor: Colors.grey.shade200,
            elevation: 0.0,
          ),
          body: loading ? Container(
            height: size.height,
              width: size.width,
              color: Colors.white,
              child: Center(child: Image.asset("assets/loading.gif"),)) : Stack(
            children: [
              SizedBox(
                height: size.height,
                width: size.width,
              ),
              Positioned(
                top: 0.0,
                left: 0.0,
                child: Image.asset("assets/images/baner_dec_left.png"),
              ),
              Positioned(
                top: 0.0,
                right: 0.0,
                child: Image.asset("assets/images/baner_dec_right.png"),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: getWidth(size, sizeInfo)),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("Welcome to e-Kodi Property Management Software", textAlign: TextAlign.center, maxLines: null, style: GoogleFonts.baloo2(fontWeight: FontWeight.w600, fontSize: 22.0,)),
                        ),
                        Text(isSignUp ? "Sign Up" : "Log In",style: GoogleFonts.baloo2(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 22.0,)),
                        AccountButton(
                          icon: "assets/google.png",
                          title: "Continue with Google",
                          authType: "google",
                          isSignUp: isSignUp,
                          onTap: ()=> handleAuth("google"),
                        ),
                        AccountButton(
                          icon: "assets/fb.png",
                          title: "Continue with Facebook",
                          authType: "facebook",
                          isSignUp: isSignUp,
                          onTap: ()=> handleAuth("facebook"),
                        ),
                        AccountButton(
                          icon: "assets/apple.png",
                          title: "Continue with Apple",
                          authType: "apple",
                          isSignUp: isSignUp,
                          onTap: ()=> handleAuth("apple"),
                        ),
                        AccountButton(
                          icon: "assets/email.png",
                          title: "Continue with Mail",
                          authType: "mail",
                          isSignUp: isSignUp,
                          onTap: ()=> handleAuth("mail"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: isSignUp ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Already have an Account? ", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 16.0,)),
                              const SizedBox(width: 5.0,),
                              RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    isSignUp = false;
                                  });
                                },
                                color: Theme.of(context).primaryColor,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                child: Text("Log In", style: GoogleFonts.baloo2(color: Colors.white)),
                              ),
                            ],
                          ) : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Don't have an Account? ", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 16.0,)),
                              const SizedBox(width: 5.0,),
                              RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    isSignUp = true;
                                  });
                                },
                                color: Theme.of(context).primaryColor,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                child: Text("Sign Up", style: GoogleFonts.baloo2(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        );
      },
    );
  }
}
