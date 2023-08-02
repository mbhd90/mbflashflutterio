import 'dart:convert';

import 'package:equatable/equatable.dart';

class CountryModel extends Equatable {
  final int id;
  final String name;
  final String code;
  final String phone_code;
  const CountryModel({
    required this.id,
    required this.name,
    required this.code,
    required this.phone_code
  });

  CountryModel copyWith({
    int? id,
    String? name,
    String? code,
    String? phone_code,
  }) {
    return CountryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      phone_code: phone_code ?? this.phone_code
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'phone_code': phone_code,
    };
  }

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      phone_code: map['phone_code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryModel.fromJson(String source) =>
      CountryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, name, code, phone_code];
}
