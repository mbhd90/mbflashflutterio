// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../home/model/brand_model.dart';
import '../../home/model/product_model.dart';
import '../../product_details/model/active_variant_model.dart';

class ProductCategoriesModel extends Equatable {

  final List<ActiveVariantModel> activeVariants;
  final List<BrandModel> brands;
  final List<ProductModel> products;
  final double maxPrice;
  const ProductCategoriesModel({
    required this.activeVariants,
    required this.brands,
    required this.products,
    required this.maxPrice,
  });


  ProductCategoriesModel copyWith({
    List<ActiveVariantModel>? activeVariants,
    List<BrandModel>? brands,
    List<ProductModel>? products,
    double? maxPrice,
  }) {
    return ProductCategoriesModel(
      activeVariants: activeVariants ?? this.activeVariants,
      brands: brands ?? this.brands,
      products: products ?? this.products,
      maxPrice:  maxPrice ?? this.maxPrice
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activeVariants': activeVariants.map((x) => x.toMap()).toList(),
      'brands': brands.map((x) => x.toMap()).toList(),
      'products': products.map((x) => x.toMap()).toList(),
      "max_price":maxPrice
    };
  }

  factory ProductCategoriesModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoriesModel(
      activeVariants: List<ActiveVariantModel>.from((map['activeVariants'] as List<dynamic>).map<ActiveVariantModel>((x) => ActiveVariantModel.fromMap(x as Map<String,dynamic>),),),
      brands: List<BrandModel>.from((map['brands'] as List<dynamic>).map<BrandModel>((x) => BrandModel.fromMap(x as Map<String,dynamic>),),),
      products: List<ProductModel>.from((map['products']['data'] as List<dynamic>).map<ProductModel>((x) => ProductModel.fromMap(x as Map<String,dynamic>),),),
      maxPrice: map['max_price']?.toDouble() ?? 100000,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCategoriesModel.fromJson(String source) => ProductCategoriesModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [activeVariants, brands, products];
}
