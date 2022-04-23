import 'package:flutter/material.dart';
import 'package:rekodi/model/account.dart';
import 'package:rekodi/model/serviceProvider.dart';

class ChatProvider with ChangeNotifier {
  Account? _receiverAccount;
  ServiceProvider? _serviceProvider;
  bool? _isServiceProvider;

  Account get receiverAccount => _receiverAccount!;
  ServiceProvider get serviceProvider => _serviceProvider!;
  bool get isServiceProvider => _isServiceProvider!;

  switchAccount(Account account) {
    _receiverAccount = account;

    notifyListeners();
  }

  switchProvider(ServiceProvider provider ) {
    _serviceProvider = provider;

    notifyListeners();
  }

  isProvider(bool isProvider) {
    _isServiceProvider = isProvider;

    notifyListeners();
  }

}