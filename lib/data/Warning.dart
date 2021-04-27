class Warning {
  final String id;
  final DateTime date;
  final String text;

  Warning({
    this.id, this.date, this.text
  });

  factory Warning.fromJson(Map<String, dynamic> json) {
    return Warning(
      id: json['_id'],
      text: json['text'],
      date: DateTime.parse(json['date'])
    );
  }
}