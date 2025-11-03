import 'package:farmacio_app/const/hashedPassword.dart';

enum UserRole { user, admin }

String roleToString(UserRole? r) => r == null ? UserRole.user.name : r.name;

UserRole roleFromString(String? s) {
  if (s == null) return UserRole.user;
  return UserRole.values.firstWhere(
    (e) => e.name == s,
    orElse: () => UserRole.user,
  );
}

class UserModel {
  final int? id;
  final String? firebaseUid;
  final String name;
  final String email;
  final String? password;
  final bool isGoogleUser;
  final String? avatarUrl;
  final String? number;
  final String? lastname;
  final UserRole? role;
  final String? classId;

  UserModel({
    this.id,
    this.firebaseUid,
    required this.name,
    required this.email,
    this.password,
    required this.isGoogleUser,
    this.avatarUrl,
    this.number,
    this.lastname,
    this.role,
    this.classId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firebaseUid': firebaseUid,
      'name': name,
      'email': email,
      // Avoid double-hashing: if the password already looks like a
      // SHA-256 hex (64 lowercase hex chars) keep it as-is, otherwise
      // hash the plaintext password.
      'password': password != null && password!.isNotEmpty
          ? (RegExp(r'^[a-f0-9]{64}$').hasMatch(password!)
                ? password
                : hashPassword(password!))
          : null,
      'isGoogleUser': isGoogleUser ? 1 : 0,
      'avatarUrl': avatarUrl,
      'number': number,
      'lastname': lastname,
      'role': roleToString(role),
      'classId': classId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firebaseUid: map['firebaseUid'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      isGoogleUser: map['isGoogleUser'] == 1 || map['isGoogleUser'] == true,
      avatarUrl: map['avatarUrl'],
      number: map['number'],
      lastname: map['lastname'],
      role: roleFromString(map['role'] as String?),
      classId: map['classId'] as String?,
    );
  }

  UserModel copyWith({
    int? id,
    String? firebaseUid,
    String? name,
    String? email,
    String? password,
    String? avatarUrl,
    String? lastname,
    String? number,
    bool? isGoogleUser,
    UserRole? role,
    String? classId,
  }) {
    return UserModel(
      id: id ?? this.id,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      lastname: lastname ?? this.lastname,
      number: number ?? this.number,
      isGoogleUser: isGoogleUser ?? this.isGoogleUser,
      role: role ?? this.role,
      classId: classId ?? this.classId,
    );
  }

  Map<String, dynamic> toFirestore() {
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'isGoogleUser': isGoogleUser ? 1 : 0,
      'role': roleToString(role),
    };
    if (classId != null) map['classId'] = classId;
    if (firebaseUid != null) map['firebaseUid'] = firebaseUid;
    return map;
  }

  factory UserModel.fromFirestore(String uid, Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      firebaseUid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'],
      isGoogleUser: map['isGoogleUser'] == 1 || map['isGoogleUser'] == true,
      avatarUrl: map['avatarUrl'],
      number: map['number'],
      lastname: map['lastname'],
      role: roleFromString(map['role'] as String?),
      classId: map['classId'] as String?,
    );
  }
}
