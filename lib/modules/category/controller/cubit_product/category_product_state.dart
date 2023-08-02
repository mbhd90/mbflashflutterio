part of 'category_product_cubit.dart';

abstract class CategoryProductState extends Equatable {
  const CategoryProductState();

  @override
  List<Object> get props => [];
}

class CategoryProductInitialState extends CategoryProductState {}

class CategoryProductLoadingState extends CategoryProductState {}

class CategoryProductErrorState extends CategoryProductState {
  final String errorMessage;
  const CategoryProductErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class CategoryProductLoadedState extends CategoryProductState {
  final List<ProductModel> categoryProducts;
  const CategoryProductLoadedState({required this.categoryProducts});

  @override
  List<Object> get props => [categoryProducts];
}
