import 'package:bloc/bloc.dart';
import 'package:bm_flash/modules/category/controller/cubit/category_cubit.dart';
import 'package:bm_flash/modules/category/controller/repository/category_repository.dart';
import 'package:bm_flash/modules/category/model/filter_model.dart';
import 'package:bm_flash/modules/category/model/product_categories_model.dart';
import 'package:bm_flash/modules/home/model/home_category_model.dart';
import 'package:bm_flash/modules/home/model/product_model.dart';
import 'package:bm_flash/modules/seller/seller_model.dart';
import 'package:equatable/equatable.dart';

part 'load_more_event.dart';
part 'load_more_state.dart';

class LoadMoreBloc extends Bloc<LoadMoreEvent, LoadMoreState> {
  final CategoryRepository _categoryRepository;
  late ProductCategoriesModel productCategoriesModel;
  late SellerProductModel homeSellerModel;
  List<ProductModel> categoryProducts = [];
  late List<ProductModel> brandProducts;
  // late List<CategoriesModel> categoryList;
  late List<HomePageCategoriesModel> categoryList;

  LoadMoreBloc(CategoryRepository categoryRepository)
      : _categoryRepository = categoryRepository,
        super(LoadMoreLoadingState());

  Future<void> loadCategoryProducts(String slug, int page, int perPage) async {
    if (state is LoadMoreLoadingState) return;

    emit(LoadMoreLoadingState());

    final result =
        await _categoryRepository.getCategoryProducts(slug, page, perPage);
    result.fold(
      (failure) {
        emit(LoadMoreErrorState(errorMessage: failure.message));
      },
      (data) {
        productCategoriesModel = data;
        categoryProducts.addAll(data.products);

        print(" --- ---- data.products ----- ---");
        print(data.products[data.products.length - 1]);
        print(" --- ---- data.products ----- ---");
        emit(LoadMoreLoadedState(products: categoryProducts));
      },
    );
  }
}
