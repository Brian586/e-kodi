import 'package:cloud_firestore/cloud_firestore.dart';

class Unit {
  final String? name;
  final String? description;
  final int? unitID;
  final String? tenantID;
  final bool? isOccupied;
  final int? price;
  final int? dueDate;
  final String? propertyID;

  Unit({this.name,this.tenantID, this.price, this.propertyID, this.dueDate, this.isOccupied, this.unitID, this.description});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "unitID": unitID,
      "tenantID": tenantID,
      "isOccupied": isOccupied,
      "price": price,
      "dueDate": dueDate,
      "propertyID": propertyID,
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
      dueDate: doc.get("dueDate") ?? "",
      propertyID: doc.get("propertyID") ?? ""
    );
  }
}