import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String? propertyID;
  final String? name;
  final String? country;
  final String? city;
  final int? units;
  final String? address;
  final String? town;
  final String? notes;
  final int? timestamp;
  final String? publisherID;
  //TODO: Add these
  // final int? occupied;
  // final int? vacant;


  Property(
      {this.name,
        this.timestamp,
        this.publisherID,
        this.propertyID,
        this.country,
        this.city,
        this.town,
        this.address,
        this.units,
        this.notes,
        // this.occupied,
        // this.vacant
      });

  Map<String, dynamic> toMap() {
    return {
      "propertyID": propertyID,
      "name": name,
      "country": country,
      "city": city,
      "town": town,
      "address": address,
      "units": units,
      "notes": notes,
      "timestamp": timestamp,
      "publisherID": publisherID,
      // "occupied": occupied,
      // "vacant": vacant,
    };
  }

  factory Property.fromDocument(DocumentSnapshot doc) {
    return Property(
      propertyID: doc.id,
      name: doc.get("name") ?? "",
      country: doc.get("country") ?? "",
      city: doc.get("city") ?? "",
      town: doc.get("town") ?? "",
      address: doc.get("address") ?? "",
      units: doc.get("units") ?? "",
      notes: doc.get("notes") ?? "",
      timestamp: doc.get("timestamp") ?? "",
      publisherID: doc.get("publisherID") ?? "",
      // vacant: doc.get("vacant") ?? "",
      // occupied: doc.get("occupied") ?? "",
    );
  }
}