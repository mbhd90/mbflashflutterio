
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../home/model/home_category_model.dart';
import '../../../seller/seller_model.dart';
import '/modules/category/controller/repository/category_repository.dart';
import '/modules/category/model/product_categories_model.dart';
import '/modules/home/model/product_model.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit(CategoryRepository categoryRepository)
      : _categoryRepository = categoryRepository,
        super(CategoryLoadingState());
  final CategoryRepository _categoryRepository;
  late ProductCategoriesModel productCategoriesModel;
  late SellerProductModel homeSellerModel;
  List<ProductModel> categoryProducts = [];
  late List<ProductModel> brandProducts;
  // late List<CategoriesModel> categoryList;
  late List<HomePageCategoriesModel> categoryList;

  Future<void> getCategoryList() async {
    emit(CategoryLoadingState());

    final result = await _categoryRepository.getCategoryList();
    result.fold(
      (failure) {
        emit(CategoryErrorState(errorMessage: failure.message));
      },
      (data) {
        categoryList = data;

        emit(CategoryListLoadedState(categoryListModel: data));
      },
    );
  }

  /*Future<void> getFilterProducts(FilterModelDto filterModelDto, int page, int perPage) async {
    emit(CategoryLoadingState());

    final result = await _categoryRepository.getFilterProducts(filterModelDto, page, perPage);
    result.fold(
      (failure) {
        emit(CategoryErrorState(errorMessage: failure.message));
      },
      (data) {
        categoryProducts = data;

        log(productCategoriesModel.products.length.toString(),
            name: "CategoryCubit");
        emit(CategoryLoadedState(categoryProducts: data));
      },
    );
  }*/
  /*
  Future<void> getBrandProduct(String slug) async {
    emit(CategoryLoadingState());

    final result = await _categoryRepository.getBrandProducts(slug);
    result.fold(
      (failure) {
        emit(CategoryErrorState(errorMessage: failure.message));
      },
      (data) {
        brandProducts = data;
        emit(CategoryLoadedState(categoryProducts: data));
      },
    );
  }

  Future<void> getSellerProduct(String slug) async {
    emit(CategoryLoadingState());

    final result = await _categoryRepository.getSellerList(slug);

    result.fold((f) {
      emit(CategoryErrorState(errorMessage: f.message));
    }, (sellerData) {
      homeSellerModel = sellerData;
      emit(SellerProductState(sellerModel: sellerData));
    });
  }*/
}
