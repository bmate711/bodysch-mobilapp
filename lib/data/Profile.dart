import 'dart:convert';

import 'package:body_sch/data/Warning.dart';

class Profile {
  final String id;
  String studentCardNumber;
  final String name;
  final String email;
  int roomNumber;
  final bool isStaffMember;
  String staffMemberText;
  final List<Warning> warnings;


  Profile({
    this.id, this.name, this.studentCardNumber, this.email,
    this.isStaffMember, this.roomNumber, this.staffMemberText,
    this.warnings,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    Iterable warningsData = json['warnings'];
    if (warningsData == null) {
      warningsData = [];
    }
    
    return Profile(
      id: json['_id'],
      studentCardNumber: json['studentCardNumber'],
      name: json['name'],
      email: json['email'],
      isStaffMember: json['isStaffMember'],
      roomNumber: json['roomNumber'],
      staffMemberText: json['staffMemberText'],
      warnings: warningsData.map((e) => Warning.fromJson(e)).toList(),
    );
  }

  String toJSON() {
    return jsonEncode(
      {
        'id': this.id,
        'studentCardNumber': this.studentCardNumber,
        'name': this.name,
        'email': this.email,
        'isStaffMember': this.isStaffMember,
        'roomNumber': this.roomNumber,
        'staffMemberText': this.staffMemberText,
      }
    );
  }
}