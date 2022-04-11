import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  final String? userID;
  final String? name;
  final String? email;
  final String? phone;
  final String? idNumber;
  final String? accountType;
  final String? photoUrl;

  Account( {this.name,this.userID, this.photoUrl, this.email, this.phone, this.idNumber, this.accountType});

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "name": name,
      "email": email,
      "phone": phone,
      "idNumber": idNumber,
      "accountType": accountType,
      "photoUrl": photoUrl
    };
  }

  factory Account.fromDocument(DocumentSnapshot doc) {
    return Account(
      userID: doc.id,
      name: doc["name"],
      email: doc["email"],
      phone: doc["phone"],
      idNumber: doc["idNumber"],
      accountType: doc["accountType"],
      photoUrl: doc["photoUrl"]
    );
  }
}