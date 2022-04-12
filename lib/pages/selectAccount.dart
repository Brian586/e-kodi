import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/config.dart';
import 'package:rekodi/model/accountType.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../providers/loader.dart';

class SelectAccount extends StatefulWidget {
  const SelectAccount({Key? key}) : super(key: key);

  @override
  State<SelectAccount> createState() => _SelectAccountState();
}

class _SelectAccountState extends State<SelectAccount> {

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

  void updateUserAccountType(BuildContext context, String accountType) async {

    String userID = Provider.of<EKodi>(context, listen: false).account.userID!;

    await FirebaseFirestore.instance.collection("users").doc(userID).update({
      "accountType": accountType
    }).then((value) {
      print("Account Updated Successfully");
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool loading = context.watch<Loader>().loading;

    return ResponsiveBuilder(
      builder: (context, sizeInfo) {

        return Scaffold(
            appBar: AppBar(
              title: const Text("Continue As ...", style: TextStyle(color: Colors.black),),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.grey,),
              ),
              centerTitle: true,
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
                        children: List.generate(accountTypes.length, (index) {
                          AccountType accountType = accountTypes[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: ()=> updateUserAccountType(context, accountType.name!),
                              child: Container(
                                width: size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    gradient: const LinearGradient(
                                        colors: [Colors.deepOrange, Colors.pink],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight
                                    )
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //Image.asset(service.icon!,width: 70.0, height: 70.0,),
                                      const SizedBox(width: 5.0,),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(accountType.name!, maxLines: 1000,  style: GoogleFonts.baloo2(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 5.0,),
                                            Text(accountType.description!, maxLines: null, style: GoogleFonts.baloo2(color: Colors.white, fontSize: 16.0,)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
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
