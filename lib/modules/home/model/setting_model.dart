import 'dart:convert';

import 'package:equatable/equatable.dart';


class SettingModel extends Equatable {
  final String logo;
  final String favicon;
  final String timezone;
  final int enableUserRegister;
  final int phoneNumberRequired;
  final int enableMultivendor;
  final String topBarEmail;
  final String topBarPhone;
  final String currencyName;
  final String currencyIcon;
  final String sellerCondition;


  const SettingModel({
    required this.logo,
    required this.favicon,
    required this.timezone,
    required this.enableUserRegister,
    required this.phoneNumberRequired,
    required this.enableMultivendor,
    required this.topBarEmail,
    required this.topBarPhone,
    required this.currencyName,
    required this.currencyIcon,
    required this.sellerCondition,
  });

  SettingModel copyWith({
    String? logo,
    String? favicon,
    String? timezone,
    int? enableUserRegister,
    int? phoneNumberRequired,
    int? enableMultivendor,
    String? topBarEmail,
    String? topBarPhone,
    String? currencyName,
    String? currencyIcon,
    String? sellerCondition,
  }) {
    return SettingModel(
      logo: logo ?? this.logo,
      favicon: favicon ?? this.favicon,
      timezone: timezone ?? this.timezone,
      enableUserRegister: enableUserRegister ?? this.enableUserRegister,
      phoneNumberRequired: phoneNumberRequired ?? this.phoneNumberRequired,
      enableMultivendor: enableMultivendor ?? this.enableMultivendor,
      topBarEmail: topBarEmail ?? this.topBarEmail,
      topBarPhone: topBarPhone ?? this.topBarPhone,
      currencyName: currencyName ?? this.currencyName,
      currencyIcon: currencyIcon ?? this.currencyIcon,
      sellerCondition: sellerCondition ?? this.sellerCondition,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'logo': logo,
      'favicon': favicon,
      'timezone': timezone,
      'enable_user_register': enableUserRegister,
      'phone_number_required': phoneNumberRequired,
      'enable_multivendor': enableMultivendor,
      'topbar_email': topBarEmail,
      'topbar_phone': topBarPhone,
      'currency_name': currencyName,
      'currency_icon': currencyIcon,
      'seller_condition': sellerCondition,
    };
  }
  // "logo": "uploads/website-images/logo-2022-11-22-11-19-02-4634.png",
  // "favicon": "uploads/website-images/favicon-2022-09-20-09-51-23-8334.png",
  // "enable_user_register": "1",
  // "enable_multivendor": "1",
  // "text_direction": "ltr",
  // "timezone": "Asia/Dhaka",
  // "topbar_phone": "123-854-7896",
  // "topbar_email": "contact@gmail.com",
  // "currency_icon": "$",
  // "currency_name": "USD",
  // "show_product_progressbar": "0",
  // "theme_one": "#fffb00",
  // "theme_two": "#b1a306",
  // "seller_condition":

  factory SettingModel.fromMap(Map<String, dynamic> map) {
    return SettingModel(
      logo: map['logo'] ?? '',
      favicon: map['favicon'] ?? '',
      timezone: map['timezone'] ?? '',
      enableUserRegister: map['enable_user_register'] != null? int.parse(map['enable_user_register'].toString()): 0,
      phoneNumberRequired: map['phone_number_required'] != null? int.parse(map['phone_number_required'].toString()): 0,
      enableMultivendor: map['enable_multivendor'] != null? int.parse(map['enable_multivendor'].toString()): 0,
      topBarEmail: map['topbar_email'] ?? '',
      topBarPhone: map['topbar_phone'] ?? '',
      currencyName: map['currency_name'] ?? '',
      currencyIcon: map['currency_icon'] ?? '',
      sellerCondition: map['seller_condition'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SettingModel.fromJson(String source) =>
      SettingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      logo,
      favicon,
      timezone,
      enableUserRegister,
      phoneNumberRequired,
      enableMultivendor,
      topBarEmail,
      topBarPhone,
      currencyName,
      currencyIcon,
      sellerCondition,
    ];
  }
}

