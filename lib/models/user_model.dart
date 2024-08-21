import 'package:flutter/foundation.dart';

@immutable
class User {
  final int? id;
  final String? username;
  final String? email;
  final String? password;
  final String? imageUrl;

  const User({
    this.id,
    this.username,
    this.email,
    this.password,
    this.imageUrl,
  });

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    String? imageUrl,
  }) =>
      User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      password: json["password"],
      imageUrl: json["image"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "image": imageUrl,
      };
}
