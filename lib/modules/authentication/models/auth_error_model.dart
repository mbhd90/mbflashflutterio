import 'dart:convert';

import 'package:equatable/equatable.dart';

class AuthErrorModel extends Equatable {
  final String message;
  final Errors errors;

  const AuthErrorModel({
    required this.message,
    required this.errors,
  });

  AuthErrorModel copyWith({
    String? message,
    Errors? errors,
  }) {
    return AuthErrorModel(
      message: message ?? this.message,
      errors: errors ?? this.errors,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'errors': errors.toMap(),
    };
  }

  factory AuthErrorModel.fromMap(Map<String, dynamic> map) {
    return AuthErrorModel(
      message: map['message'] as String,
      errors: Errors.fromMap(map['errors'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthErrorModel.fromJson(String source) =>
      AuthErrorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [message, errors];
}

class Errors extends Equatable {
  final List<String> name;
  final List<String> agree;
  final List<String> email;
  final List<String> password;
  final List<String> phone;
  final List<String> country;
  final List<String> state;
  final List<String> city;
  final List<String> address;
  final List<String> type;
  final List<String> subject;
  final List<String> message;
  final List<String> review;

  final List<String> openAt;
  final List<String> closedAt;
  final List<String> bannerImage;
  final List<String> logo;
  final List<String> termCondition;
  final List<String> shopName;

  const Errors({
    required this.name,
    required this.email,
    required this.agree,
    required this.password,
    required this.phone,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.type,
    required this.subject,
    required this.message,
    required this.review,
    required this.openAt,
    required this.closedAt,
    required this.bannerImage,
    required this.logo,
    required this.termCondition,
    required this.shopName,
  });

  Errors copyWith({
    List<String>? name,
    List<String>? agree,
    List<String>? email,
    List<String>? password,
    List<String>? phone,
    List<String>? country,
    List<String>? state,
    List<String>? city,
    List<String>? address,
    List<String>? type,
    List<String>? subject,
    List<String>? message,
    List<String>? review,
    List<String>? openAt,
    List<String>? closedAt,
    List<String>? bannerImage,
    List<String>? logo,
    List<String>? termCondition,
    List<String>? shopName,
  }) {
    return Errors(
      name: name ?? this.name,
      email: email ?? this.email,
      agree: email ?? this.agree,
      password: email ?? this.password,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      type: type ?? this.type,
      subject: subject ?? this.subject,
      message: message ?? this.message,
      review: review ?? this.review,
      openAt: openAt ?? this.openAt,
      closedAt: closedAt ?? this.closedAt,
      bannerImage: bannerImage ?? this.bannerImage,
      logo: logo ?? this.logo,
      termCondition: termCondition ?? this.termCondition,
      shopName: shopName ?? this.shopName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'agree': agree,
      'password': password,
      'phone': phone,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'type': type,
      'subject': subject,
      'message': message,
      'review': review,
      'banner_image': bannerImage,
      'open_at': openAt,
      'closed_at': closedAt,
      'agree_terms_condition': termCondition,
      'logo': logo,
      'shop_name': shopName,
    };
  }

  factory Errors.fromMap(Map<String, dynamic> map) {
    return Errors(
      name: map['name'] != null
          ? List<String>.from(map['name'].map((x) => x))
          : [],
      email: map['email'] != null
          ? List<String>.from(map['email'].map((x) => x))
          : [],
      agree: map['agree'] != null
          ? List<String>.from(map['agree'].map((x) => x))
          : [],
      password: map['password'] != null
          ? List<String>.from(map['password'].map((x) => x))
          : [],
      phone: map['phone'] != null
          ? List<String>.from(map['phone'].map((x) => x))
          : [],
      country: map['country'] != null
          ? List<String>.from(map['country'].map((x) => x))
          : [],
      state: map['state'] != null
          ? List<String>.from(map['state'].map((x) => x))
          : [],
      city: map['city'] != null
          ? List<String>.from(map['city'].map((x) => x))
          : [],
      address: map['address'] != null
          ? List<String>.from(map['address'].map((x) => x))
          : [],
      type: map['type'] != null
          ? List<String>.from(map['type'].map((x) => x))
          : [],
      subject: map['subject'] != null
          ? List<String>.from(map['subject'].map((x) => x))
          : [],
      message: map['message'] != null
          ? List<String>.from(map['message'].map((x) => x))
          : [],
      review: map['review'] != null
          ? List<String>.from(map['review'].map((x) => x))
          : [],
      logo: map['logo'] != null
          ? List<String>.from(map['logo'].map((x) => x))
          : [],
      shopName: map['shop_name'] != null
          ? List<String>.from(map['shop_name'].map((x) => x))
          : [],
      bannerImage: map['banner_image'] != null
          ? List<String>.from(map['banner_image'].map((x) => x))
          : [],
      openAt: map['open_at'] != null
          ? List<String>.from(map['open_at'].map((x) => x))
          : [],
      closedAt: map['closed_at'] != null
          ? List<String>.from(map['closed_at'].map((x) => x))
          : [],
      termCondition: map['agree_terms_condition'] != null
          ? List<String>.from(map['agree_terms_condition'].map((x) => x))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Errors.fromJson(String source) =>
      Errors.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        name,
        email,
        agree,
        password,
        phone,
        country,
        state,
        city,
        address,
        type,
        subject,
        message,
        review,
        bannerImage,
        openAt,
        closedAt,
        termCondition,
        logo,
        shopName,
      ];
}
