import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bm_flash/modules/category/controller/repository/category_repository.dart';
import 'package:bm_flash/modules/category/model/filter_model.dart';
import 'package:bm_flash/modules/seller/seller_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/modules/home/model/product_model.dart';

part 'seller_product_state.dart';

class SellerProductCubit extends Cubit<SellerProductState> {
  SellerProductCubit(CategoryRepository categoryRepository)
      : _categoryRepository = categoryRepository,
        super(SellerProductLoadingState());
  final CategoryRepository _categoryRepository;

  late SellerProductModel homeSellerModel;
  List<int> brands = [];
  
  List<String> variantsItem = [];

  late double maxValue = 100000;
  late double minValue = 0;

  late double upperValue = 1000;
  late double lowerValue = 0;

  late int page = 1;
  late String seller = "";
  late int perPage = 10;
  late bool fliter = false;
  late bool loaded = false;
  
  late FilterModelDto? _filterModelDto;

  void reset() {
    brands.clear();
    variantsItem.clear();
    lowerValue = 0;
    upperValue = 1000;
    minValue = 0;
    page = 1;
    late int perPage = 10;
    late bool fliter = false;
    maxValue = 100000;
    seller = "";
    fliter = false;
    // ignore: unnecessary_null_comparison
    if(loaded){
      homeSellerModel.products.clear();
      homeSellerModel.activeVariants.clear();
      homeSellerModel.brands.clear();
    }
    loaded = false;
  }

  Future<void> getSellerProduct(String slug) async {
    page = 1;
    seller = slug;
    emit(SellerProductLoadingState());
    print(" --- ---- getSellerProduct ----- ---");
    print(page);
    print(" --- ---- getSellerProduct ----- ---");

    final result = await _categoryRepository.getSellerList(slug, page, perPage);

    result.fold((f) {
      emit(SellerProductErrorState(errorMessage: f.message));
    }, (sellerData) {
      homeSellerModel = sellerData;
      loaded = true;
      
      page++;
        
    print(" --- ---- homeSellerModel.products.length.toString() ----- ---");
    print(homeSellerModel.products.length.toString());
    print(" --- ---- homeSellerModel.products.length.toString() ----- ---");
      log(homeSellerModel.products.length.toString(),
            name: "SellerProductCubit");
            
            
      emit(SellerProductLoadedState(sellerModel: sellerData));
    });
  }
  
  Future<void> loadSellerProduct(String slug) async {
    if (state is SellerProductLoadingState) return;
    seller = slug;
    
    fliter = false;
    emit(SellerProductLoadingState());
    print(" --- ---- loadSellerProduct ----- ---");
    print(page);
    print(" --- ---- loadSellerProduct ----- ---");

    final result =
        await _categoryRepository.loadSellerList(slug, page, perPage);
    result.fold(
      (failure) {
        emit(SellerProductErrorState(errorMessage: failure.message));
      },
      (data) {     
        if(page == 1){
          homeSellerModel.products.clear();
        }
        homeSellerModel.products.addAll(data);
        //if(data.products.isNotEmpty){
          page++;
        //}
        
    print(" --- ---- homeSellerModel.products.length.toString() ----- ---");
    print(homeSellerModel.products.length.toString());
    print(" --- ---- homeSellerModel.products.length.toString() ----- ---");
        log(homeSellerModel.products.length.toString(),
            name: "SellerProductCubit");
        
        emit(SellerProductLoadedState(sellerModel: homeSellerModel));
      },
    );
  }
  
  Future<void> getFilterSellerProducts(FilterModelDto filterModelDto) async {
    if (state is SellerProductLoadingState) return;
    _filterModelDto = filterModelDto;
    fliter = true;
    emit(SellerProductLoadingState());
    print(" --- ---- getFilterProducts ----- ---");
    print(page);
    print(" --- ---- getFilterProducts ----- ---");
    final result = await _categoryRepository.getFilterSellersProducts(filterModelDto,  seller, page, perPage);
    result.fold(
      (failure) {
        emit(SellerProductErrorState(errorMessage: failure.message));
      },
      (data) {
        if(page == 1){
          homeSellerModel.products.clear();
        }
        homeSellerModel.products.addAll(data);
        //if(data.products.isNotEmpty){
          page++;
        //}
        
    print(" --- ---- homeSellerModel.products.length.toString() ----- ---");
    print(homeSellerModel.products.length.toString());
    print(" --- ---- homeSellerModel.products.length.toString() ----- ---");
        log(homeSellerModel.products.length.toString(),
            name: "SellerProductCubit");
        
        emit(SellerProductLoadedState(sellerModel: homeSellerModel));
      },
    );
  }
}
