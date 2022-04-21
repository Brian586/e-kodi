import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceProvider {
  final String? providerID;
  final String? title;
  final String? email;
  final String? phone;
  final String? city;
  final String? country;
  final String? description;
  final String? photoUrl;
  final List<dynamic>? ratings;
  final int? rating;
  final int? timestamp;
  final String? category;

  ServiceProvider(
      {this.providerID,
      this.title,
      this.email,
      this.phone,
      this.city,
      this.country,
        this.ratings,
        this.rating,
        this.timestamp,
        this.category,
        this.photoUrl,
      this.description});

  Map<String, dynamic> toMap() {
    return {
      "providerID": providerID,
      "title": title,
      "email": email,
      "phone": phone,
      "city": city,
      "country": country,
      "description": description,
      "photoUrl": photoUrl,
      "ratings": ratings,
      "rating": rating,
      "timestamp": timestamp,
      "category": category,
    };
  }

  factory ServiceProvider.fromDocument(DocumentSnapshot doc) {
    return ServiceProvider(
      providerID: doc.id,
      title: doc.get("title") ?? "",
      email: doc.get("email") ?? "",
      phone: doc.get("phone") ?? "",
      city: doc.get("city") ?? "",
      country: doc.get("country") ?? "",
      description: doc.get("description") ?? "",
      photoUrl: doc.get("photoUrl") ?? "",
      ratings: doc.get("ratings") ?? "",
      rating: doc.get("rating") ?? "",
      timestamp: doc.get("timestamp") ?? "",
      category: doc.get("category") ?? ""
    );
  }

}