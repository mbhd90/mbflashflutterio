part of 'product_details_cubit.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object> get props => [];
}

class ProductDetailsStateLoading extends ProductDetailsState {}

class ProductDetailsStateError extends ProductDetailsState {
  final String errorMessage;
  const ProductDetailsStateError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ProductDetailsStateLoaded extends ProductDetailsState {
  final ProductDetailsModel productDetailsModel;
  const ProductDetailsStateLoaded(this.productDetailsModel);

  @override
  List<Object> get props => [productDetailsModel];
}
