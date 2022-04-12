import 'package:flutter/material.dart';

class Loader with ChangeNotifier {
  bool? _loading = false;

  bool get loading => _loading!;

  switchLoadingState(bool value) {
    _loading = value;

    notifyListeners();
  }

}