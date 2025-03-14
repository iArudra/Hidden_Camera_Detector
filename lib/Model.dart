class Report {
  final int? id;
  final String location;
  final String date;
  final String description;
  final int reportCount;

  Report({
    this.id,
    required this.location,
    required this.date,
    required this.description,
    required this.reportCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'location': location,
      'date': date,
      'description': description,
      'reportCount': reportCount,
    };
  }

  static Report fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id'],
      location: map['location'],
      date: map['date'],
      description: map['description'],
      reportCount: map['reportCount'],
    );
  }
}
