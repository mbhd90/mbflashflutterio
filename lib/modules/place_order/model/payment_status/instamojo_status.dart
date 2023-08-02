// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class InstamojoStatus extends Equatable {
  final int status;

  const InstamojoStatus({
    required this.status,
  });

  InstamojoStatus copyWith({
    int? status,
  }) {
    return InstamojoStatus(
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
    };
  }

  factory InstamojoStatus.fromMap(Map<String, dynamic> map) {
    return InstamojoStatus(
      status: map['status'] != null ? int.parse(map['status'].toString()) : 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory InstamojoStatus.fromJson(String source) =>
      InstamojoStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [status];
}
