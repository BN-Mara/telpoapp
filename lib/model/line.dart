class Line {
  int? id;
  String? name;
  String? region;

  Line({this.id, this.name, this.region});

  // Factory method to create a Line instance from a JSON object
  factory Line.fromJson(Map<String, dynamic> json) {
    return Line(
      id: json['id'] as int?,
      name: json['name'] as String?,
      region: json['region'] as String?,
    );
  }

  // Method to convert a Line instance into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region,
    };
  }
}
