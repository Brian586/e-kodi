import 'package:flutter/material.dart';

class DatePeriodProvider with ChangeNotifier {
  int? _startDate = DateTime.now().millisecondsSinceEpoch - (2*2.628e+9).toInt();
  int? _endDate = DateTime.now().millisecondsSinceEpoch;

  int get startDate => _startDate!;
  int get endDate => _endDate!;

  updatePeriod({int? start, int? end}) {
    _startDate = start;
    _endDate = end;

    notifyListeners();
  }
}