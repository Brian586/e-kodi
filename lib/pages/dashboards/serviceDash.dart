import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekodi/chat/chatDetails.dart';
import 'package:rekodi/chat/chatHome.dart';
import 'package:rekodi/main.dart';
import 'package:rekodi/model/serviceProvider.dart';
import 'package:rekodi/widgets/customTextField.dart';
import 'package:rekodi/widgets/loadingAnimation.dart';

import '../../config.dart';
import '../../model/account.dart';

class ServiceDash extends StatefulWidget {
  const ServiceDash({Key? key}) : super(key: key);

  @override
  State<ServiceDash> createState() => _ServiceDashState();
}

class _ServiceDashState extends State<ServiceDash> {
  bool loading = false;

  TextEditingController _title = TextEditingController();
  TextEditingController _category = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _description = TextEditingController();

  @override
  void initState() {
    super.initState();

    getServiceProviderInfo();
  }

  getServiceProviderInfo() async {
    setState(() {
      loading = true;
    });

    String userID = Provider.of<EKodi>(context, listen: false).account.userID!;

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("serviceProviders")
        .doc(userID)
        .get();

    if (!documentSnapshot.exists) {
      ServiceProvider provider = await showDetailsDialog(userID);

      await FirebaseFirestore.instance
          .collection("serviceProviders")
          .doc(provider.providerID)
          .set(provider.toMap());

      await context.read<EKodi>().switchServiceProvider(provider);

      setState(() {
        loading = false;
      });
    } else {
      ServiceProvider provider = ServiceProvider.fromDocument(documentSnapshot);

      await context.read<EKodi>().switchServiceProvider(provider);

      setState(() {
        loading = false;
      });
    }
  }

  showDetailsDialog(String userID) async {
    Size size = MediaQuery.of(context).size;
    bool isOther = false;

    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text("Service Provision: Getting Started"),
            content: Container(
              height: size.height * 0.6,
              width: size.width * 0.4,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AuthTextField(
                      controller: _title,
                      prefixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      hintText: "Company Name/Sole_P",
                      isObscure: false,
                      inputType: TextInputType.name,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text("Select Service Category",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.baloo2(
                            fontSize: 16.0,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: DropdownSearch<String>(
                        // dropdownSearchDecoration: InputDecoration(
                        //   border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(30.0),
                        //       borderSide: const BorderSide(
                        //         width: 1.0,
                        //       )
                        //   ),
                        // ),
                        mode: Mode.MENU,
                        showSelectedItems: true,
                        items: const [
                          "Plumber",
                          "Electrician",
                          "Beauty & Cosmetics",
                          "Internet Service Provider(WiFi)",
                          "Cleaners",
                          "Wood & Metal Works",
                          "Tutor",
                          "Security",
                          "Other"
                        ],
                        hint: "Categories",
                        onChanged: (v) {
                          if (v == "Other") {
                            setState(() {
                              isOther = true;
                              _category.clear();
                            });

                            print(isOther);
                          } else {
                            setState(() {
                              _category.text = v!;
                              isOther = false;
                            });
                            print(isOther);
                          }
                        },
                        //selectedItem: "Tenant"
                      ),
                    ),
                    AuthTextField(
                      controller: _category,
                      prefixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      hintText: "If other, state the Service Category",
                      isObscure: false,
                      inputType: TextInputType.name,
                    ),
                    AuthTextField(
                      controller: _phone,
                      prefixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      hintText: "Company Phone (+254)",
                      isObscure: false,
                      inputType: TextInputType.phone,
                    ),
                    AuthTextField(
                      controller: _email,
                      prefixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      hintText: "Company Email Address",
                      isObscure: false,
                      inputType: TextInputType.emailAddress,
                    ),
                    AuthTextField(
                      controller: _city,
                      prefixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      hintText: "City",
                      isObscure: false,
                      inputType: TextInputType.text,
                    ),
                    AuthTextField(
                      controller: _country,
                      prefixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      hintText: "Country",
                      isObscure: false,
                      inputType: TextInputType.text,
                    ),
                    AuthTextField(
                      controller: _description,
                      prefixIcon: const SizedBox(
                        height: 0.0,
                        width: 0.0,
                      ),
                      hintText: "Service Description",
                      isObscure: false,
                      inputType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  if (_title.text.isNotEmpty &&
                      _email.text.isNotEmpty &&
                      _phone.text.isNotEmpty &&
                      _city.text.isNotEmpty &&
                      _country.text.isNotEmpty &&
                      _description.text.isNotEmpty) {
                    ServiceProvider provider = ServiceProvider(
                      providerID: userID,
                      title: _title.text.trim(),
                      email: _email.text.trim(),
                      phone: _phone.text.trim(),
                      city: _city.text.trim(),
                      country: _country.text.trim(),
                      photoUrl: "",
                      description: _description.text.trim(),
                      rating: 0,
                      ratings: [],
                      timestamp: DateTime.now().millisecondsSinceEpoch,
                      category: _category.text.trim(),
                    );

                    Navigator.of(context).pop(provider);
                  }
                },
                icon: Icon(Icons.done, color: Theme.of(context).primaryColor),
                label: Text(
                  "Proceed",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            ],
          );
        });
  }

  displayUserProfile(Account account) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(18.0),
          child: account.photoUrl! == ""
              ? Image.asset(
                  "assets/profile.png",
                  height: 36.0,
                  width: 36.0,
                )
              : Image.network(
                  account.photoUrl!,
                  height: 36.0,
                  width: 36.0,
                ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account.name!,
              style: const TextStyle(color: Colors.white, fontSize: 13.0),
            ),
            Text(
              account.accountType!,
              style: const TextStyle(color: Colors.white30, fontSize: 11.0),
            )
          ],
        ),
        //const SizedBox(width: 10.0,),
        PopupMenuButton<String>(
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
          offset: const Offset(0.0, 0.0),
          onSelected: (v) async {
            switch (v) {
              case "My Account":
                //Go to account page
                break;
              case "Settings":
                //Go to settings page
                break;
              case "Logout":
                //Logout user
                await FirebaseAuth.instance.signOut();

                Route route = MaterialPageRoute(
                    builder: (context) => const SplashScreen());

                Navigator.pushReplacement(context, route);
            }
          },
          itemBuilder: (BuildContext context) {
            return ["My Account", "Settings", "Logout"].map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Account account = context.watch<EKodi>().account;
    Size size = MediaQuery.of(context).size;
    ServiceProvider provider = context.watch<EKodi>().serviceProvider;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Row(
          children: [
            RichText(
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
            const SizedBox(
              width: 10.0,
            ),
            const VerticalDivider(
              color: Colors.grey,
            ),
            Icon(
              Icons.phone,
              color: Colors.blueAccent.shade700,
              size: 15.0,
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "+254701518100",
                  style: TextStyle(color: Colors.white, fontSize: 13.0),
                ),
                Text(
                  "Help & Support",
                  style: TextStyle(color: Colors.white30, fontSize: 11.0),
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_active_rounded,
              color: Colors.white30,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.question_answer_outlined,
              color: Colors.white30,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          loading ? Container() : displayUserProfile(account),
          const SizedBox(
            width: 20.0,
          ),
        ],
      ),
      body: loading
          ? const LoadingAnimation()
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 35,
                  child: ChatHome(),
                ),
                VerticalDivider(
                  color: Colors.grey.shade300,
                  width: 1.0,
                  thickness: 1.0,
                ),
                Expanded(
                  flex: 35,
                  child: ChatDetails(),
                ),
                VerticalDivider(
                  color: Colors.grey.shade300,
                ),
                Expanded(
                  flex: 30,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(35.0),
                        child: provider.photoUrl! == ""
                            ? Image.asset(
                                "assets/profile.png",
                                height: 70.0,
                                width: 70.0,
                                fit: BoxFit.cover,
                              )
                            : Image.network(provider.photoUrl!,
                                height: 70.0, width: 70.0, fit: BoxFit.cover),
                      ),
                      Text(provider.title!),
                      Text(provider.email!),
                      Text(provider.phone!),
                      Text(
                        provider.description!,
                        maxLines: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
