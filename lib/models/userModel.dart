import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? password;

  const User({
    this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.password,
  });

  toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "password": password,
    };
    }
  

  factory User.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return User(
      id: document.id,
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      password: data['password'],
    );
  }
}