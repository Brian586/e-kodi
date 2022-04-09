import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekodi/widgets/accountButton.dart';
import 'package:responsive_builder/responsive_builder.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ResponsiveBuilder(
      builder: (context, sizeInfo) {

        bool isMobile = sizeInfo.isMobile;

        return Scaffold(
          appBar: AppBar(
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
          body: Stack(
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
                      ),
                      AccountButton(
                        icon: "assets/fb.png",
                        title: "Continue with Facebook",
                        authType: "facebook",
                        isSignUp: isSignUp,
                      ),
                      AccountButton(
                        icon: "assets/apple.png",
                        title: "Continue with Apple",
                        authType: "apple",
                        isSignUp: isSignUp,
                      ),
                      AccountButton(
                        icon: "assets/email.png",
                        title: "Continue with Mail",
                        authType: "mail",
                        isSignUp: isSignUp,
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
              )
            ],
          )
        );
      },
    );
  }
}
