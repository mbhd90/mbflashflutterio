import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/modules/home/model/product_model.dart';

import '../repository/home_repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(HomeRepository homeRepository)
      : _homeRepository = homeRepository,
        super(ProductsInitial());

  final HomeRepository _homeRepository;
  late List<ProductModel> hightlightedProducts = [];
  int page = 1;
  int perPage = 10;
  late bool fliter = false;

  late double maxValue = 100000;
  late double minValue = 0;

  late double upperValue = 1000;
  late double lowerValue = 0;

  
  reset(){
    hightlightedProducts.clear();
    lowerValue = 0;
    upperValue = 1000;
    minValue = 0;
    page = 1;
    maxValue = 100000;
    fliter = false;
  }
  //SearchResponseModel
  Future<void> getHighlightedProduct(String keyword) async {
    emit(ProductsStateLoading());

    final result = await _homeRepository.getHighlightProducts(keyword, page, perPage);
    result.fold(
      (failuer) {
        emit(ProductsStateError(errorMessage: failuer.message));
      },
      (data) {
        print("---- data.products ----");
        print(data.products);
        print("---- data.products ----");
            if(page == 1){
              hightlightedProducts.clear();
            }
            if(data.products.isNotEmpty){
              hightlightedProducts.addAll(data.products);
            }
            page++;
        emit(ProductsStateLoaded(highlightedProducts: hightlightedProducts));
      },
    );
  }

  Future<void> loadMoreData(String keyword) async {
    if (state is ProductsStateLoading) return;
    emit(ProductsStateLoading());

    final result = await _homeRepository.loadMoreProducts(keyword,page, perPage);
    result.fold(
          (failure) {
        emit(ProductsStateError(errorMessage: failure.message));
      },
          (data) {
            if(page == 1){
              hightlightedProducts.clear();
            }
            if(data.products.isNotEmpty){
              hightlightedProducts.addAll(data.products);
            }
            page++;

        emit(ProductsStateLoaded(highlightedProducts: hightlightedProducts));
      },
    );
  }
}
