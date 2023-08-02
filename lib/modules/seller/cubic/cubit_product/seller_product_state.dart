part of 'seller_product_cubit.dart';

abstract class SellerProductState extends Equatable {
  const SellerProductState();

  @override
  List<Object> get props => [];
}

class SellerProductInitialState extends SellerProductState {}

class SellerProductLoadingState extends SellerProductState {}

class SellerProductErrorState extends SellerProductState {
  final String errorMessage;
  const SellerProductErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class SellerProductLoadedState extends SellerProductState {
  final SellerProductModel sellerModel;
  const SellerProductLoadedState({required this.sellerModel});

  @override
  List<Object> get props => [sellerModel];
}