class ProfileSearchItem {
  final String id;
  final String studentCardNumber;
  final String name;

  ProfileSearchItem({this.id, this.name, this.studentCardNumber});

  factory ProfileSearchItem.fromJson(Map<String, dynamic> json) {
    return ProfileSearchItem(
      id: json['_id'],
      studentCardNumber: json['studentCardNumber'],
      name: json['name'],
    );
  }
}