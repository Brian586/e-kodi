import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? messageID;
  final String? senderID;
  final String? receiverID;
  final String? messageDescription;
  final int? timestamp;
  final bool? isWithImage;
  final bool? seen;
  final bool? isServiceProvider;
  final Map<String, dynamic>? senderInfo;


  Message(
      {this.messageID,
        this.senderID,
        this.receiverID,
        this.messageDescription,
        this.timestamp,
        this.isWithImage,
        this.isServiceProvider,
        this.senderInfo,
        this.seen});

  Map<String, dynamic> toMap() {
    return {
      "messageID": messageID,
      "senderID": senderID,
      "receiverID": receiverID,
      "messageDescription": messageDescription,
      "timestamp": timestamp,
      "isWithImage": isWithImage,
      "seen": seen,
      "senderInfo": senderInfo,
      "isServiceProvider": isServiceProvider
    };
  }

  factory Message.fromDocument(DocumentSnapshot doc) {
    return Message(
      messageID: doc.id,
      senderID: doc.get("senderID") ?? "",
      receiverID:  doc.get("receiverID") ?? "",
      messageDescription:  doc.get("messageDescription") ?? "",
      timestamp:  doc.get("timestamp") ?? "",
      isWithImage:  doc.get("isWithImage") ?? "",
      isServiceProvider:  doc.get("isServiceProvider") ?? "",
      senderInfo:  doc.get("senderInfo") ?? "",
      seen:  doc.get("seen") ?? "",
    );
  }


}