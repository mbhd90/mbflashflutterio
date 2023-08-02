
import 'package:bloc/bloc.dart';
import 'package:bm_flash/modules/home/model/brand_model.dart';
import 'package:equatable/equatable.dart';
import '/modules/category/controller/repository/category_repository.dart';
import '/modules/home/model/product_model.dart';

part 'brand_state.dart';

class BrandCubit extends Cubit<BrandState> {
  BrandCubit(CategoryRepository categoryRepository)
      : _categoryRepository = categoryRepository,
        super(BrandListLoadingState());
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
  
  Future<void> getBrandList() async {
    emit(BrandListLoadingState());

    final result = await _categoryRepository.getBrandList();
    result.fold(
      (failure) {
        emit(BrandListErrorState(errorMessage: failure.message));
      },
      (data) {
        brandsList = data;

        emit(BrandListLoadedState(brands: brandsList));
      },
    );
  }
}
