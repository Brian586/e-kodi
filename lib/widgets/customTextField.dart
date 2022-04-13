import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;

  const CustomTextField(
      {Key? key, this.controller, this.hintText,})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Container(
        width: size.width,
        height: 40.0,
        decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: TextFormField(
              controller: widget.controller,
              maxLines: null,
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 16.0,),
              decoration: InputDecoration.collapsed(
                fillColor: Colors.cyan.shade300,
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;

  const SearchTextField(
      {Key? key, this.controller, this.hintText,})
      : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: size.width*0.2,
        height: 40.0,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: TextFormField(
              controller: widget.controller,
              maxLines: null,
              cursorColor: Colors.black,
              style: const TextStyle(fontSize: 14.0,),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 15.0,),
                border: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0)
              ),
            ),
          ),
        ),
      ),
    );
  }
}