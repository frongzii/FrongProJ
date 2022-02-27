import 'dart:convert';

class UserModel {
  final String email;
  final String name;
  final String password;
  final String typeuser;
  UserModel({
    required this.email,
    required this.name,
    required this.password,
    required this.typeuser,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'typeuser': typeuser,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'],
      name: map['name'],
      password: map['password'],
      typeuser: map['typeuser'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
