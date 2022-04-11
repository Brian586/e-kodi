import 'package:flutter/material.dart';

import 'model/account.dart';

class EKodi with ChangeNotifier {
  Account? _account;

  Account get account => _account!;

  switchUser(Account acc) {
    _account = acc;

    notifyListeners();
  }
}