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
                //prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 15.0,),
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

class MyTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final double? width;
  final String? title;

  const MyTextField({Key? key, this.controller, this.hintText, this.width, this.title}) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: SizedBox(
        width: widget.width,
        height: 60.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title!, style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),),
            const SizedBox(height: 5.0,),
            Container(
              width: widget.width,
              height: 35.0,
              decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(5.0),
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 0),
                        spreadRadius: 3.0,
                        //blurRadius: 3.0,
                        color: isSelected ? Colors.grey.shade400 : Colors.transparent
                    )
                  ]
              ),
              child: FocusScope(
                onFocusChange: (v) {
                  setState(() {
                    isSelected = v;
                  });
                },
                child: TextFormField(
                  controller: widget.controller,
                  cursorColor: Theme.of(context).primaryColor,
                  style: const TextStyle(fontSize: 12.0, height: 1.5, color: Colors.black),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                            width: 2.0,
                            color: Colors.grey
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                        )),
                    fillColor: Colors.white,
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
