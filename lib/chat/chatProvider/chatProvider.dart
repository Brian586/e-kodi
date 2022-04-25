import 'package:flutter/material.dart';
import 'package:rekodi/model/account.dart';
import 'package:rekodi/model/serviceProvider.dart';

class ChatProvider with ChangeNotifier {
  Account? _receiverAccount;
  bool? _isOpen = false;

  Account get receiverAccount => _receiverAccount!;
  bool get isOpen => _isOpen!;

  switchAccount(Account account) {
    _receiverAccount = account;

    notifyListeners();
  }

  openChatDetails(bool value) {
    _isOpen = value;

    notifyListeners();
  }

}