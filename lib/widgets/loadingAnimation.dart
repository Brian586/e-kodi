import 'package:flutter/material.dart';


class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: Center(child: Image.asset("assets/loading.gif"),));
  }
}
