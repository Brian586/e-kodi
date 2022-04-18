import 'package:cloud_firestore/cloud_firestore.dart';

class Unit {
  final String? name;
  final String? description;
  final int? unitID;
  final String? tenantID;
  final bool? isOccupied;
  final int? price;

  Unit({this.name,this.tenantID, this.price, this.isOccupied, this.unitID, this.description});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "unitID": unitID,
      "tenantID": tenantID,
      "isOccupied": isOccupied,
      "price": price,
    };
  }

  factory Unit.fromDocument(DocumentSnapshot doc) {
    return Unit(
      name: doc.get("name") ?? "",
      description: doc.get("description") ?? "",
      unitID: doc.get("unitID") ?? "",
      tenantID: doc.get("tenantID") ?? "",
      isOccupied: doc.get("isOccupied") ?? "",
      price: doc.get("price") ?? "",
    );
  }
}