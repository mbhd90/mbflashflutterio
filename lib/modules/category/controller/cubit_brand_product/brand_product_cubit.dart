import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bm_flash/modules/home/model/brand_model.dart';
import 'package:equatable/equatable.dart';
import '/modules/category/controller/repository/category_repository.dart';
import '/modules/home/model/product_model.dart';

part 'brand_product_state.dart';

class BrandProductCubit extends Cubit<BrandProductState> {
  BrandProductCubit(CategoryRepository categoryRepository)
      : _categoryRepository = categoryRepository,
        super(BrandProductLoadingState());
  final CategoryRepository _categoryRepository;
  late List<ProductModel> brandProducts = [];
  
  late List<BrandModel> brandsList;

  List<String> variantsItem = [];
  List<String> categories = [];

  late double maxValue = 100000;
  late double minValue = 0;

  late double upperValue = 1000;
  late double lowerValue = 0;

  late int page = 1;
  late String brand = "";
  late int perPage = 10;
  late bool fliter = false;

  reset(){
    brandProducts.clear();
    categories.clear();
    variantsItem.clear();
    lowerValue = 0;
    upperValue = 1000;
    minValue = 0;
    page = 1;
    maxValue = 100000;
    fliter = false;
    brand = "";
  }
  
  Future<void> getBrandProduct(String slug) async {
    emit(BrandProductLoadingState());
    brand = slug;
    page = 1;

    final result = await _categoryRepository.getBrandProducts(slug, page, perPage);
    result.fold(
      (failure) {
        emit(BrandProductErrorState(errorMessage: failure.message));
      },
      (data) {
        brandProducts = data;
        page++;
        
        log(brandProducts.length.toString(),
            name: "BrandCubit");
        emit(BrandProductLoadedState(brandProducts: data));
      },
    );
  }

  Future<void> loadBrandProduct(String slug) async {
    print(" --- ---- BrandLoadingState ----- ---");
    print(state);
    if (state is BrandProductLoadingState) return;

    emit(BrandProductLoadingState());
    brand = slug;
    final result = await _categoryRepository.getBrandProducts(slug, page, perPage);
    result.fold(
      (failure) {
        emit(BrandProductErrorState(errorMessage: failure.message));
      },
      (data) {
        if(page == 1){
          brandProducts.clear();
        }
        brandProducts.addAll(data);
        
        log(brandProducts.length.toString(),
            name: "BrandCubit");
        emit(BrandProductLoadedState(brandProducts: data));
      },
    );
  }
}
