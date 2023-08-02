import 'dart:convert';

import 'package:equatable/equatable.dart';

class ActiveVariantItemModel extends Equatable {
  final int productVariantId;
  final int id;
  final String name;
  final double price;

  const ActiveVariantItemModel({
    required this.productVariantId,
    required this.id,
    required this.name,
    required this.price,
  });

  ActiveVariantItemModel copyWith({
    int? productVariantId,
    int? id,
    String? name,
    double? price,
  }) {
    return ActiveVariantItemModel(
      productVariantId: productVariantId ?? this.productVariantId,
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'product_variant_id': productVariantId});
    result.addAll({'id': id});
    result.addAll({'name': name});
    result.addAll({'price': price});

    return result;
  }

  factory ActiveVariantItemModel.fromMap(Map<String, dynamic> map) {
    return ActiveVariantItemModel(
      productVariantId: map['product_variant_id'] != null
          ? int.parse(map['product_variant_id'].toString())
          : 0,
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      price: map['price'] != null ? double.parse(map['price'].toString()) : 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActiveVariantItemModel.fromJson(String source) =>
      ActiveVariantItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VariantItemModel(product_variant_id: $productVariantId, id: $id, name: $name, price: $price)';
  }

  @override
  List<Object> get props {
    return [
      productVariantId,
      id,
      name,
      price,
    ];
  }
}
