import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
import '../widgets/customTextField.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isSignUp = false;
  TextEditingController name =  TextEditingController();
  TextEditingController phone =  TextEditingController();
  TextEditingController email =  TextEditingController();
  TextEditingController password =  TextEditingController();
  TextEditingController cPassword =  TextEditingController();
  String accountType = 'Tenant';

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

  void handleAuth(BuildContext context) async {
    await context.read<Loader>().switchLoadingState(true);

    String res = "";//await Authentication().performAuthentication(context,/* authType!,*/ isSignUp);

    if(isSignUp) {
      res = await Authentication().createUserWithEmail(
        name: name.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
        phone: phone.text.trim(),
        accountType: accountType,
      );
    }
    else
      {
        res = await Authentication().loginUserWithEmail(
          email: email.text.trim(),
          password: password.text.trim(),
        );
      }

    await context.read<Loader>().switchLoadingState(false);

    if(res.split("+").first == "success")
    {
      await FirebaseFirestore.instance.collection("users").doc(res.split("+").last).get().then((value) {
        Account account = Account.fromDocument(value);

        context.read<EKodi>().switchUser(account);
      });

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
                        Text(isSignUp ? "Create Account" : "Log In",style: GoogleFonts.baloo2(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 22.0,)),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: isSignUp ? [
                            AuthTextField(
                              controller: name,
                              prefixIcon: const Icon(Icons.person, color: Colors.grey,),
                              hintText: "Username",
                              isObscure: false,
                              inputType: TextInputType.name,
                            ),
                            AuthTextField(
                              controller: phone,
                              prefixIcon: const Icon(Icons.phone, color: Colors.grey,),
                              hintText: "Phone (+254)",
                              isObscure: false,
                              inputType: TextInputType.phone,
                            ),
                            AuthTextField(
                              controller: email,
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey,),
                              hintText: "Email Address",
                              isObscure: false,
                              inputType: TextInputType.emailAddress,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Continue as...", textAlign: TextAlign.start, style: GoogleFonts.baloo2(fontSize: 16.0,)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                              child: DropdownSearch<String>(
                                  mode: Mode.MENU,
                                  showSelectedItems: true,
                                  items: const ["Landlord", "Tenant", "Agent", "Service Provider"],
                                  hint: "Continue as...",
                                  onChanged: (v) {
                                    setState(() {
                                      accountType = v!;
                                    });
                                  },
                                  selectedItem: "Tenant"),
                            ),
                            AuthTextField(
                              controller: password,
                              prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.grey,),
                              hintText: "Password",
                              isObscure: true,
                              inputType: TextInputType.visiblePassword,
                            ),
                            AuthTextField(
                              controller: cPassword,
                              prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.grey,),
                              hintText: "Confirm Password",
                              isObscure: true,
                              inputType: TextInputType.visiblePassword,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: RaisedButton.icon(
                                onPressed: ()=> handleAuth(context),
                                color: Theme.of(context).primaryColor,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                label: Text("Create", style: GoogleFonts.baloo2(color: Colors.white)),
                                icon: const Icon(Icons.done, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Already have an Account? ", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 16.0,)),
                                  const SizedBox(width: 5.0,),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isSignUp = false;
                                        name.clear();
                                        phone.clear();
                                        email.clear();
                                        password.clear();
                                        cPassword.clear();
                                      });
                                    },
                                    child: Text("Log In", style: GoogleFonts.baloo2(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ),
                          ] : [
                            AuthTextField(
                              controller: email,
                              prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey,),
                              hintText: "Email Address",
                              isObscure: false,
                              inputType: TextInputType.emailAddress,
                            ),
                            AuthTextField(
                              controller: password,
                              prefixIcon: const Icon(Icons.lock_open, color: Colors.grey,),
                              hintText: "Password",
                              isObscure: true,
                              inputType: TextInputType.visiblePassword,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: RaisedButton.icon(
                                onPressed: ()=> handleAuth(context),
                                color: Theme.of(context).primaryColor,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                label: Text("Login", style: GoogleFonts.baloo2(color: Colors.white)),
                                icon: const Icon(Icons.done, color: Colors.white,),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Don't have an Account? ", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 16.0,)),
                                  const SizedBox(width: 5.0,),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isSignUp = true;
                                        email.clear();
                                        password.clear();
                                      });
                                    },
                                    child: Text("Create", style: GoogleFonts.baloo2(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
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
