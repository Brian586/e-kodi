import 'package:flutter/material.dart';
import 'package:rekodi/model/serviceProvider.dart';

import 'model/account.dart';

class EKodi with ChangeNotifier {
  Account? _account;
  ServiceProvider? _serviceProvider;
  // bool? _isServiceProvider;

  Account get account => _account!;
  ServiceProvider get serviceProvider => _serviceProvider!;
  // bool get isServiceProvider => _isServiceProvider!;

  switchUser(Account acc) {
    _account = acc;

    notifyListeners();
  }

  switchServiceProvider(ServiceProvider provider) {
    _serviceProvider = provider;

    notifyListeners();
  }

  // isProvider(bool isProvider) {
  //   _isServiceProvider = isProvider;
  //
  //   notifyListeners();
  // }
}