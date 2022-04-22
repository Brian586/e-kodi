class Message {
  final String? messageID;
  final String? senderID;
  final String? receiverID;
  final String? messageDescription;
  final int? timestamp;
  final bool? isWithImage;
  final bool? seen;


  Message(
      {this.messageID,
        this.senderID,
        this.receiverID,
        this.messageDescription,
        this.timestamp,
        this.isWithImage,
        this.seen});


}