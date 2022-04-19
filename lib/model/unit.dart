import 'package:cloud_firestore/cloud_firestore.dart';

class Unit {
  final String? name;
  final String? description;
  final int? unitID;
  final String? tenantID;
  final bool? isOccupied;
  final int? rent;
  final int? deposit;
  final int? dueDate;
  final int? startDate;
  final String? propertyID;
  final String? paymentFreq;
  final int? reminder;

  Unit({
    this.name,
    this.tenantID,
    this.rent,
    this.propertyID,
    this.dueDate,
    this.isOccupied,
    this.unitID,
    this.description,
    this.startDate,
    this.deposit,
    this.paymentFreq,
    this.reminder,
  });

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "unitID": unitID,
      "tenantID": tenantID,
      "isOccupied": isOccupied,
      "rent": rent,
      "dueDate": dueDate,
      "propertyID": propertyID,
      "startDate": startDate,
      "deposit": deposit,
      "paymentFreq": paymentFreq,
      "reminder": reminder
    };
  }

  factory Unit.fromDocument(DocumentSnapshot doc) {
    return Unit(
      name: doc.get("name") ?? "",
      description: doc.get("description") ?? "",
      unitID: doc.get("unitID") ?? "",
      tenantID: doc.get("tenantID") ?? "",
      isOccupied: doc.get("isOccupied") ?? "",
      rent: doc.get("rent") ?? "",
      dueDate: doc.get("dueDate") ?? "",
      propertyID: doc.get("propertyID") ?? "",
      deposit: doc.get("deposit") ?? "",
      startDate: doc.get("startDate") ?? "",
      paymentFreq: doc.get("paymentFreq") ?? "",
      reminder: doc.get("reminder") ?? "",
    );
  }
}