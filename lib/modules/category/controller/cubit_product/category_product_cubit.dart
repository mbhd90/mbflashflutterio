import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bm_flash/modules/category/controller/repository/category_repository.dart';
import 'package:bm_flash/modules/category/model/filter_model.dart';
import 'package:bm_flash/modules/seller/seller_model.dart';
import 'package:equatable/equatable.dart';
// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/modules/category/model/product_categories_model.dart';
import '/modules/home/model/product_model.dart';

part 'category_product_state.dart';

class CategoryProductCubit extends Cubit<CategoryProductState> {
  CategoryProductCubit(CategoryRepository categoryRepository)
      : _categoryRepository = categoryRepository,
        super(CategoryProductLoadingState());
  final CategoryRepository _categoryRepository;

  late ProductCategoriesModel productCategoriesModel;

  List<ProductModel> categoryProducts = [];
  List<int> brands = [];
  
  List<String> variantsItem = [];

  late double maxValue = 100000;
  late double minValue = 0;

  late double upperValue = 1000;
  late double lowerValue = 0;

  late int page = 1;
  late String category = "";
  late int perPage = 10;
  late bool fliter = false;

  late SellerProductModel homeSellerModel;
  
  late FilterModelDto _filterModelDto;
  void reset() {
    categoryProducts.clear();
    brands.clear();
    variantsItem.clear();
    lowerValue = 0;
    upperValue = 1000;
    minValue = 0;
    page = 1;
    maxValue = 100000;
    category = "";
    fliter = false;
  }


  Future<void> getCategoryProduct(String slug) async {
    //if (state is CategoryProductLoadingState) return;
    /*if(fliter){
        getFilterProducts(_filterModelDto);
        return;
    }*/
    page = 1;
    category = slug;
    emit(CategoryProductLoadingState());
    print(" --- ---- getCategoryProduct ----- ---");
    print(page);
    print(" --- ---- getCategoryProduct ----- ---");
    fliter = false;

    final result =
        await _categoryRepository.getCategoryProducts(slug, page, perPage);
    result.fold(
      (failure) {
        emit(CategoryProductErrorState(errorMessage: failure.message));
      },
      (data) {
        productCategoriesModel = data;
        categoryProducts = data.products;
        maxValue = data.maxPrice.toDouble();
        
        print(" --- ---- maxValue ----- ---");
        print(maxValue);
        print(" --- ---- maxValue ----- ---");

        //if(data.products.isNotEmpty){
          page++;
        //}
        
        log(productCategoriesModel.products.length.toString(),
            name: "CategoryProductCubit");
        emit(CategoryProductLoadedState(categoryProducts: data.products));
      },
    );
  }

  Future<void> loadCategoryProducts(String slug) async {
    print(" --- ---- CategoryProductLoadingState ----- ---");
    print(state);
    if (state is CategoryProductLoadingState) return;
    category = slug;
    
    if(fliter){
        getFilterProducts(_filterModelDto);
        return;
    }

    fliter = false;
    emit(CategoryProductLoadingState());
    print(" --- ---- loadCategoryProducts ----- ---");
    print(page);
    print(" --- ---- loadCategoryProducts ----- ---");

    final result =
        await _categoryRepository.getCategoryProducts(slug, page, perPage);
    result.fold(
      (failure) {
        emit(CategoryProductErrorState(errorMessage: failure.message));
      },
      (data) {       
        if(page == 1){
          productCategoriesModel.products.clear();
        }
        productCategoriesModel.products.addAll(data.products);
        
        maxValue = data.maxPrice.toDouble();
        //if(data.products.isNotEmpty){
          page++;
        //}
        log(productCategoriesModel.products.length.toString(),
            name: "CategoryProductCubit");
        emit(CategoryProductLoadedState(categoryProducts: categoryProducts));
      },
    );
  }

  Future<void> getFilterProducts(FilterModelDto filterModelDto) async {
    if (state is CategoryProductLoadingState) return;
    _filterModelDto = filterModelDto;
    fliter = true;
    emit(CategoryProductLoadingState());
    print(" --- ---- getFilterProducts ----- ---");
    print(page);
    print(" --- ---- getFilterProducts ----- ---");
    
    if(page == 1){
      productCategoriesModel.products.clear();
    }
    final result = await _categoryRepository.getFilterProducts(filterModelDto,  category, page, perPage);
    result.fold(
      (failure) {
        emit(CategoryProductErrorState(errorMessage: failure.message));
      },
      (data) {
        productCategoriesModel.products.addAll(data);
        //if(data.products.isNotEmpty){
          page++;
        //}
        log(productCategoriesModel.products.length.toString(),
            name: "CategoryProductCubit");
        emit(CategoryProductLoadedState(categoryProducts: data));
      },
    );
  }
}
