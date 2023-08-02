part of 'brand_product_cubit.dart';

abstract class BrandProductState extends Equatable {
  const BrandProductState();

  @override
  List<Object> get props => [];
}

class BrandProductInitialState extends BrandProductState {}

class BrandProductLoadingState extends BrandProductState {}

class BrandProductErrorState extends BrandProductState {
  final String errorMessage;
  const BrandProductErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class BrandProductLoadedState extends BrandProductState {
  final List<ProductModel> brandProducts;
  const BrandProductLoadedState({required this.brandProducts});

  @override
  List<Object> get props => [brandProducts];
}
