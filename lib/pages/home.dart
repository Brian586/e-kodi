import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rekodi/model/feature.dart';
import 'package:rekodi/model/service.dart' as myServices;
import 'package:rekodi/widgets/appBar.dart';
import 'package:rekodi/widgets/customTextField.dart';
import 'package:rekodi/widgets/drawer.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      breakpoints: const ScreenBreakpoints(
          tablet: 600,
          desktop: 950,
          watch: 300
      ),
      mobile: (BuildContext context) => const HomeMobile(),
      tablet: (BuildContext context) => const HomeTablet(),
      desktop: (BuildContext context) => const HomeDesktop(),
      watch: (BuildContext context) => Container(color:Colors.white),
    );
  }
}


class HomeMobile extends StatefulWidget {
  const HomeMobile({Key? key}) : super(key: key);

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Image.asset("assets/wa.png"),
      ),
      drawer: const CustomDrawer(),
      appBar: PreferredSize(
        child: CustomAppBar(scaffoldKey: _scaffoldKey,),
        preferredSize: Size(size.width, 70.0),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: size.height*0.6,
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
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("WELCOME TO e-KODI"),
                        const SizedBox(height: 10.0,),
                        RichText(
                          textScaleFactor: 4.0,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Digitize ', style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.bold)),
                              TextSpan(text: 'your ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                              TextSpan(text: 'Business ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                              TextSpan(text: '& ', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                              TextSpan(text: 'streamline your ', style: GoogleFonts.ptSans(color: Colors.red,fontWeight: FontWeight.bold)),
                              TextSpan(text: 'workflow', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        Text("Re-kodi property management provides All-in-one solution to centralise customer data and provide workforce mobility", textAlign: TextAlign.center, style: GoogleFonts.baloo2()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/images/banner_right_image.png"),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(myServices.services.length, (index) {
                myServices.Service service = myServices.services[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
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
                          Image.asset(service.icon!,width: 70.0, height: 70.0,),
                          const SizedBox(width: 5.0,),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(service.name!, maxLines: 1000,  style: GoogleFonts.baloo2(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 5.0,),
                                Text(service.description!, maxLines: null, style: GoogleFonts.baloo2(color: Colors.white, fontSize: 16.0,)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            Image.asset("assets/images/about-left-image.png"),
            Image.asset("assets/images/services_left_image.png"),
            RichText(
              textScaleFactor: 3.0,
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(text: 'Grow Your Business With Our ', style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Smart ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Property Management ', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                  TextSpan(text: 'Software ', style: GoogleFonts.ptSans(color: Colors.red,fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Your Business solutions", maxLines: null, style: GoogleFonts.baloo2( fontSize: 16.0,)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("We provide smart solutions that automate processes to meet tenants and Landloards needs. Our cloud-based property management software provides simple and affordable cloud property management software that enables managers of residential and association properties to take complete control of their business, including rent, vacancy, and maintenance cycles.", maxLines: null, style: GoogleFonts.baloo2( fontSize: 16.0,)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tenant rate", maxLines: null, style: GoogleFonts.baloo2( fontWeight: FontWeight.bold, fontSize: 16.0,)),
                  Text("84%", maxLines: null, style: GoogleFonts.baloo2(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 16.0,)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: LinearPercentIndicator(
                width: size.width - 30.0,
                lineHeight: 5.0,
                percent: 0.84,
                animation: true,
                animationDuration: 2500,
                linearStrokeCap: LinearStrokeCap.butt,
                backgroundColor: Colors.grey.shade200,
                progressColor: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Return On Investment", maxLines: null, style: GoogleFonts.baloo2( fontWeight: FontWeight.bold, fontSize: 16.0,)),
                  Text("88%", maxLines: null, style: GoogleFonts.baloo2(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 16.0,)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: LinearPercentIndicator(
                width: size.width - 30.0,
                lineHeight: 5.0,
                percent: 0.88,
                animation: true,
                animationDuration: 2500,
                linearStrokeCap: LinearStrokeCap.butt,
                backgroundColor: Colors.grey.shade200,
                progressColor: Colors.red,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Customer Satisfaction", maxLines: null, style: GoogleFonts.baloo2( fontWeight: FontWeight.bold, fontSize: 16.0,)),
                  Text("94%", maxLines: null, style: GoogleFonts.baloo2(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 16.0,)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: LinearPercentIndicator(
                width: size.width - 30.0,
                lineHeight: 5.0,
                percent: 0.94,
                animation: true,
                animationDuration: 2500,
                linearStrokeCap: LinearStrokeCap.butt,
                backgroundColor: Colors.grey.shade200,
                progressColor: Colors.red,
              ),
            ),
            const SizedBox(height: 20.0,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RichText(
                textScaleFactor: 3.0,
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'See What Our App ', style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Offers ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                    TextSpan(text: '& How It ', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Functions ', style: GoogleFonts.ptSans(color: Colors.red,fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(features.length, (index) {
                  Feature feature = features[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.0),
                    child: Container(
                      width: size.width,
                      height: size.height*0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Theme.of(context).scaffoldBackgroundColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 3.0,
                            blurRadius: 3.0
                          )
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(feature.icon!,),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Container(
              width: size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/contact_bg.png"),
                  fit: BoxFit.fitHeight
                )
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Feel Free To Send Us a Message About Your Website Needs", textAlign: TextAlign.center, maxLines: null, style: GoogleFonts.baloo2(fontWeight: FontWeight.w600, fontSize: 22.0,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("We are here for you", maxLines: null, style: GoogleFonts.baloo2(color: Colors.white, fontSize: 18.0,)),
                    ),
                    Text("For any enquiry, Call Us:", maxLines: null, style: GoogleFonts.baloo2(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_phone_rounded, color: Colors.white,),
                        const SizedBox(width: 10.0,),
                        Text("+254-797-383-995", maxLines: null, style: GoogleFonts.baloo2(color: Colors.white,  fontSize: 20.0,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Container(
                      width: size.width,
                      //height: size.height*0.6,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize:  MainAxisSize.min,
                          children: [
                            CustomTextField(
                              controller: name,
                              hintText: "Name",
                            ),
                            CustomTextField(
                              controller: surname,
                              hintText: "Surname",
                            ),
                            CustomTextField(
                              controller: email,
                              hintText: "Your Email",
                            ),
                            CustomTextField(
                              controller: message,
                              hintText: "Message",
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: RaisedButton(
                                onPressed: () {},
                                color: Colors.blue,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                child: Text("Send Message", style: GoogleFonts.baloo2(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("\u00a9 e-kodi,Inc", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 18.0)),
                Text("All Rights Reserved.", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 18.0)),
              ],
            ),
            const SizedBox(height: 20.0,),
          ],
        ),
      ),
    );
  }
}

class HomeTablet extends StatefulWidget {
  const HomeTablet({Key? key}) : super(key: key);

  @override
  State<HomeTablet> createState() => _HomeTabletState();
}

class _HomeTabletState extends State<HomeTablet> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        child: CustomAppBar(scaffoldKey: _scaffoldKey,),
        preferredSize: Size(size.width, 70.0),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: size.height*0.4,
                  width: size.width,
                ),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  child: Image.asset("assets/images/baner_dec_left.png", height: size.height*0.4,),
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Image.asset("assets/images/baner_dec_right.png"),
                ),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("WELCOME TO e-KODI"),
                        const SizedBox(height: 10.0,),
                        RichText(
                          textScaleFactor: 4.0,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Digitize ', style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.bold)),
                              TextSpan(text: 'your ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                              TextSpan(text: 'Business ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                              TextSpan(text: '& ', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                              TextSpan(text: 'streamline your ', style: GoogleFonts.ptSans(color: Colors.red,fontWeight: FontWeight.bold)),
                              TextSpan(text: 'workflow', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10.0,),
                        Text("Re-kodi property management provides All-in-one solution to centralise customer data and provide workforce mobility", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 18.0)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("assets/images/banner_right_image.png"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(myServices.services.length, (index) {
                  myServices.Service service = myServices.services[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
                            Image.asset(service.icon!,width: 70.0, height: 70.0,),
                            const SizedBox(width: 5.0,),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(service.name!, maxLines: 1000,  style: GoogleFonts.baloo2(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 5.0,),
                                  Text(service.description!, maxLines: null, style: GoogleFonts.baloo2(color: Colors.white, fontSize: 16.0,)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
                child: Image.asset("assets/images/about-left-image.png", height: size.height*0.4,)),
            Image.asset("assets/images/services_left_image.png"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: RichText(
                textScaleFactor: 3.0,
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Grow Your Business With Our ', style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Smart ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Property Management ', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Software ', style: GoogleFonts.ptSans(color: Colors.red,fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Your Business solutions", maxLines: null, style: GoogleFonts.baloo2( fontSize: 20.0,)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: Text("We provide smart solutions that automate processes to meet tenants and Landloards needs. Our cloud-based property management software provides simple and affordable cloud property management software that enables managers of residential and association properties to take complete control of their business, including rent, vacancy, and maintenance cycles.", maxLines: null, style: GoogleFonts.baloo2( fontSize: 16.0,)),
            ),
            const SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tenant rate", maxLines: null, style: GoogleFonts.baloo2( fontWeight: FontWeight.bold, fontSize: 16.0,)),
                  Text("84%", maxLines: null, style: GoogleFonts.baloo2(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 16.0,)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: LinearPercentIndicator(
                width: size.width - size.width*0.2,
                lineHeight: 5.0,
                percent: 0.84,
                animation: true,
                animationDuration: 2500,
                linearStrokeCap: LinearStrokeCap.butt,
                backgroundColor: Colors.grey.shade200,
                progressColor: Colors.red,
              ),
            ),
            const SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Return On Investment", maxLines: null, style: GoogleFonts.baloo2( fontWeight: FontWeight.bold, fontSize: 16.0,)),
                  Text("88%", maxLines: null, style: GoogleFonts.baloo2(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 16.0,)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: LinearPercentIndicator(
                width: size.width - size.width*0.2,
                lineHeight: 5.0,
                percent: 0.88,
                animation: true,
                animationDuration: 2500,
                linearStrokeCap: LinearStrokeCap.butt,
                backgroundColor: Colors.grey.shade200,
                progressColor: Colors.red,
              ),
            ),
            const SizedBox(height: 30.0,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Customer Satisfaction", maxLines: null, style: GoogleFonts.baloo2( fontWeight: FontWeight.bold, fontSize: 16.0,)),
                  Text("94%", maxLines: null, style: GoogleFonts.baloo2(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 16.0,)),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: LinearPercentIndicator(
                width: size.width - size.width*0.2,
                lineHeight: 5.0,
                percent: 0.94,
                animation: true,
                animationDuration: 2500,
                linearStrokeCap: LinearStrokeCap.butt,
                backgroundColor: Colors.grey.shade200,
                progressColor: Colors.red,
              ),
            ),
            const SizedBox(height: 60.0,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: RichText(
                textScaleFactor: 3.0,
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'See What Our App ', style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Offers ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                    TextSpan(text: '& How It ', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Functions ', style: GoogleFonts.ptSans(color: Colors.red,fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(features.length, (index) {
                  Feature feature = features[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
                    child: Container(
                      width: size.width,
                      height: size.height*0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 3.0,
                                blurRadius: 3.0
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(feature.icon!,),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 50.0,),
            Container(
              width: size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/contact_bg.png"),
                      fit: BoxFit.fitHeight
                  )
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 100.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Feel Free To Send Us a Message About Your Website Needs", textAlign: TextAlign.center, maxLines: null, style: GoogleFonts.baloo2(fontWeight: FontWeight.w600, fontSize: 30.0,)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("We are here for you", maxLines: null, style: GoogleFonts.baloo2(color: Colors.white, fontSize: 18.0,)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("For any enquiry, Call Us:", maxLines: null, style: GoogleFonts.baloo2(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,)),
                        const SizedBox(width: 10.0,),
                        const Icon(Icons.local_phone_rounded, color: Colors.white,),
                        const SizedBox(width: 10.0,),
                        Text("+254-797-383-995", maxLines: null, style: GoogleFonts.baloo2(color: Colors.white,  fontSize: 20.0,)),
                      ],
                    ),
                    const SizedBox(height: 10.0,),
                    Container(
                      width: size.width,
                      //height: size.height*0.6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize:  MainAxisSize.min,
                          children: [
                            CustomTextField(
                              controller: name,
                              hintText: "Name",
                            ),
                            CustomTextField(
                              controller: surname,
                              hintText: "Surname",
                            ),
                            CustomTextField(
                              controller: email,
                              hintText: "Your Email",
                            ),
                            CustomTextField(
                              controller: message,
                              hintText: "Message",
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: RaisedButton(
                                onPressed: () {},
                                color: Colors.blue,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0)
                                ),
                                child: Text("Send Message", style: GoogleFonts.baloo2(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("\u00a9 e-kodi,Inc", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 18.0)),
                Text("All Rights Reserved.", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 18.0)),
              ],
            ),
            const SizedBox(height: 20.0,),
          ],
        ),
      ),
    );
  }
}

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({Key? key}) : super(key: key);

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Image.asset("assets/wa.png"),
      // ),
      drawer: const CustomDrawer(),
      appBar: PreferredSize(
        child: CustomAppBar(scaffoldKey: _scaffoldKey,),
        preferredSize: Size(size.width, 70.0),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: size.height*0.9,
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
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  top: 0.0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text("WELCOME TO e-KODI"),
                              const SizedBox(height: 10.0,),
                              RichText(
                                textScaleFactor: 4.0,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(text: 'Digitize ', style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.bold)),
                                    TextSpan(text: 'your ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                                    TextSpan(text: 'Business ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                                    TextSpan(text: '& ', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                                    TextSpan(text: 'streamline your ', style: GoogleFonts.ptSans(color: Colors.red,fontWeight: FontWeight.bold)),
                                    TextSpan(text: 'workflow', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10.0,),
                              Text("Re-kodi property management provides All-in-one solution to centralise customer data and provide workforce mobility", textAlign: TextAlign.center, style: GoogleFonts.baloo2()),
                            ],
                          ),
                        ),
                        //const SizedBox(width: 20.0,),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset("assets/images/banner_right_image.png", width: size.width*0.45, height: size.height*0.8,),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Container(
              width: size.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/about_bg.png"),
                      fit: BoxFit.fitWidth
                  )
              ),
              child: Padding(
                padding: EdgeInsets.all(size.width*0.1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/images/about-left-image.png", width: size.width*0.4, ),
                    Expanded(
                      child: SizedBox(
                        height: size.height*0.5,
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: size.width*0.2/250.0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(myServices.services.length, (index) {
                            myServices.Service service = myServices.services[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                //width: size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(service.icon!,width: 70.0, height: 70.0,),
                                      const SizedBox(width: 5.0,),
                                      Expanded(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(service.name!, maxLines: 1000,  style: GoogleFonts.baloo2(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 5.0,),
                                            Text(service.description!, maxLines: null, style: GoogleFonts.baloo2(color: Colors.white, fontSize: 16.0,)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width*0.1),
              child: Row(
                children: [
                  Image.asset("assets/images/services_left_image.png", width: size.width*0.4,),
                  Expanded(
                    child: Column(
                      children: [
                        RichText(
                          textScaleFactor: 3.0,
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: 'Grow Your Business With Our ', style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.bold)),
                              TextSpan(text: 'Smart ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                              TextSpan(text: 'Property Management ', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                              TextSpan(text: 'Software ', style: GoogleFonts.ptSans(color: Colors.red,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("Your Business solutions", maxLines: null, style: GoogleFonts.baloo2( fontSize: 16.0,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("We provide smart solutions that automate processes to meet tenants and Landloards needs. Our cloud-based property management software provides simple and affordable cloud property management software that enables managers of residential and association properties to take complete control of their business, including rent, vacancy, and maintenance cycles.", maxLines: null, style: GoogleFonts.baloo2( fontSize: 16.0,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tenant rate", maxLines: null, style: GoogleFonts.baloo2( fontWeight: FontWeight.bold, fontSize: 16.0,)),
                              Text("84%", maxLines: null, style: GoogleFonts.baloo2(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 16.0,)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: LinearPercentIndicator(
                            width: size.width*0.35,
                            lineHeight: 5.0,
                            percent: 0.84,
                            animation: true,
                            animationDuration: 2500,
                            linearStrokeCap: LinearStrokeCap.butt,
                            backgroundColor: Colors.grey.shade200,
                            progressColor: Colors.red,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Return On Investment", maxLines: null, style: GoogleFonts.baloo2( fontWeight: FontWeight.bold, fontSize: 16.0,)),
                              Text("88%", maxLines: null, style: GoogleFonts.baloo2(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 16.0,)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: LinearPercentIndicator(
                            width: size.width*0.35,
                            lineHeight: 5.0,
                            percent: 0.88,
                            animation: true,
                            animationDuration: 2500,
                            linearStrokeCap: LinearStrokeCap.butt,
                            backgroundColor: Colors.grey.shade200,
                            progressColor: Colors.red,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Customer Satisfaction", maxLines: null, style: GoogleFonts.baloo2( fontWeight: FontWeight.bold, fontSize: 16.0,)),
                              Text("94%", maxLines: null, style: GoogleFonts.baloo2(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold, fontSize: 16.0,)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: LinearPercentIndicator(
                            width: size.width*0.35,
                            lineHeight: 5.0,
                            percent: 0.94,
                            animation: true,
                            animationDuration: 2500,
                            linearStrokeCap: LinearStrokeCap.butt,
                            backgroundColor: Colors.grey.shade200,
                            progressColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 50.0,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: RichText(
                textScaleFactor: 3.0,
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'See What Our App ', style: GoogleFonts.ptSans(color: Colors.black, fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Offers ', style: GoogleFonts.ptSans(color: Colors.blue,fontWeight: FontWeight.bold)),
                    TextSpan(text: '& How It ', style: GoogleFonts.ptSans(color: Colors.black,fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Functions ', style: GoogleFonts.ptSans(color: Colors.red,fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(features.length, (index) {
                  Feature feature = features[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.0),
                    child: Container(
                      width: size.width*0.15,
                      height: size.height*0.18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 3.0,
                                blurRadius: 3.0
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(feature.icon!,),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Container(
              width: size.width,
              height: size.height*0.9,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/contact_bg.png"),
                      fit: BoxFit.fitWidth
                  )
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.1, vertical: 60.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text("Feel Free To Send Us a Message About Your Website Needs", textAlign: TextAlign.center, maxLines: null, style: GoogleFonts.baloo2(fontWeight: FontWeight.w600, fontSize: 22.0,)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text("We are here for you", maxLines: null, style: GoogleFonts.baloo2(color: Colors.white, fontSize: 18.0,)),
                            ),
                            Text("For any enquiry, Call Us:", maxLines: null, style: GoogleFonts.baloo2(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0,)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.local_phone_rounded, color: Colors.white,),
                                const SizedBox(width: 10.0,),
                                Text("+254-797-383-995", maxLines: null, style: GoogleFonts.baloo2(color: Colors.white,  fontSize: 20.0,)),
                              ],
                            ),
                            const SizedBox(height: 10.0,),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            width: size.width*0.4,
                            height: size.height*0.4,
                          ),
                          Positioned(
                            bottom: 0.0,
                            top: 0.0,
                            left: 0.0,
                            child: Container(
                              width: size.width*0.3,
                              //height: size.height*0.7,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize:  MainAxisSize.min,
                                  children: [
                                    CustomTextField(
                                      controller: name,
                                      hintText: "Name",
                                    ),
                                    CustomTextField(
                                      controller: surname,
                                      hintText: "Surname",
                                    ),
                                    CustomTextField(
                                      controller: email,
                                      hintText: "Your Email",
                                    ),
                                    CustomTextField(
                                      controller: message,
                                      hintText: "Message",
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RaisedButton(
                                        onPressed: () {},
                                        color: Colors.blue,
                                        elevation: 5.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30.0)
                                        ),
                                        child: Text("Send Message", style: GoogleFonts.baloo2(color: Colors.white)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 0.0,
                              top: 0.0,
                              right: 0.0,
                              child: Image.asset("assets/images/contact_decoration.png", width: size.width*0.2,))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("\u00a9 e-kodi,Inc", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 18.0)),
                Text("All Rights Reserved.", textAlign: TextAlign.center, style: GoogleFonts.baloo2(fontSize: 18.0)),
              ],
            ),
            const SizedBox(height: 20.0,),
          ],
        ),
      ),
    );
  }
}