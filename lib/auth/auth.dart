import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/model/account.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:rekodi/model/accountType.dart';
import 'package:rekodi/providers/loader.dart';
import 'package:rekodi/widgets/customTextField.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Authentication {

  performAuthentication(BuildContext context, String authType, bool isSignUp) async {

    if(isSignUp) { //New users
      switch (authType) {
        case "google":
          UserCredential userCredential;

          if(kIsWeb)
            {
              userCredential = await webSignInWithGoogle();
            }
          else
            {
              userCredential = await nativeSignInWithGoogle();
            }

          //TODO: Display popup to take the necessary data

          Account account = Account(
            name: userCredential.user!.displayName,
            userID: userCredential.user!.uid,
            email: userCredential.user!.email,
            // phone: phone!,
            // idNumber: idNo!,
            // accountType: accountType!,
            photoUrl: userCredential.user!.photoURL,
          );

          String res = await saveUserInfoToFirestore(account);

          return res;

        case "apple":
        // do something else
          return "";

        case "facebook":
        // do something else
          return "";

        case "mail":
          TextEditingController _name = TextEditingController();
          TextEditingController _phone = TextEditingController();
          TextEditingController _id = TextEditingController();
          TextEditingController _email = TextEditingController();
          TextEditingController _password = TextEditingController();
          TextEditingController _cPassword = TextEditingController();

        // TODO: Display popup
          await showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return ResponsiveBuilder(
                builder: (context, sizeInfo) {
                  Size size = MediaQuery.of(context).size;
                  bool isMobile = sizeInfo.isMobile;
                  bool isTablet = sizeInfo.isTablet;

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 7.0 : isTablet ? size.width*0.1 : size.width*0.25),
                    child: AlertDialog(
                      title: const Text('Continue with Email'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            CustomTextField(
                              controller: _name,
                              hintText: "Name",
                            ),
                            CustomTextField(
                              controller: _phone,
                              hintText: "Phone",
                            ),
                            CustomTextField(
                              controller: _id,
                              hintText: "ID Number",
                            ),
                            CustomTextField(
                              controller: _email,
                              hintText: "Email",
                            ),
                            CustomTextField(
                              controller: _password,
                              hintText: "Password",
                            ),
                            CustomTextField(
                              controller: _cPassword,
                              hintText: "Confirm Password",
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Approve'),
                          onPressed: () {
                            if(_name.text.isNotEmpty
                                && _phone.text.isNotEmpty
                                && _email.text.isNotEmpty && _id.text.isNotEmpty
                                && _password.text.isNotEmpty && _cPassword.text.isNotEmpty && _password.text == _cPassword.text)
                              {
                                context.read<Loader>().switchLoadingState(true);

                                Navigator.pop(context);
                              }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );

          String res = await createUserWithEmail(
            name: _name.text.trim(),
            email: _email.text.trim(),
            password: _password.text.trim(),
            phone: _phone.text.trim(),
            accountType: "",
            idNo: _id.text.trim()
          );

          return res;
      }
    }
    else {
      switch (authType) {
        case "google":
        // do something
          return "";
        case "apple":
        // do something else
          return "";
        case "facebook":
        // do something else
          return "";
        case "mail":
        // do something else
          return "";
      }
    }
  }

  Future<String> saveUserInfoToFirestore(Account account) async {
    await FirebaseFirestore.instance.collection("users").doc(account.userID).set(account.toMap());

    return "success";
  }

  Future<String> createUserWithEmail({String? name, String? email, String? password, String? phone, String? idNo, String? accountType}) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      Account account = Account(
        name: name!,
        userID: credential.user!.uid,
        email: credential.user!.email,
        phone: phone!,
        idNumber: idNo!,
        accountType: accountType!,
        photoUrl: credential.user!.photoURL ?? "",
      );

      String res = await saveUserInfoToFirestore(account);

      return res;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "weak password";
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');

        return "user exists";
      }
      else {
        return "failed";
      }
    } catch (e) {
      print(e);
      return "failed";
    }
  }

  Future<UserCredential> nativeSignInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);



  }

  Future<UserCredential> webSignInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    // googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
    // googleProvider.setCustomParameters({
    //   'login_hint': email!
    // });

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

}