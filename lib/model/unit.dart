class Unit {
  final String? name;
  final String? description;
  final int? unitID;

  Unit({this.name, this.unitID, this.description});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "unitID": unitID,
    };
  }
}