import 'package:flutter/foundation.dart';

@immutable
class Contact {
  final int? id;
  final String? name;
  final String? codeId;
  final int? userId;

  const Contact({
    this.id,
    this.name,
    this.codeId,
    this.userId,
  });

  Contact copyWith({
    int? id,
    String? name,
    String? codeId,
    int? userId,
  }) =>
      Contact(
        id: id ?? this.id,
        name: name ?? this.name,
        codeId: codeId ?? this.codeId,
        userId: userId ?? this.userId,
      );

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        id: json["id"],
        name: json["name"],
        codeId: json["code"].toString(),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": double.parse(codeId.toString()),
        "user_id": userId,
      };
}
