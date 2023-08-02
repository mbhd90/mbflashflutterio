part of 'brand_cubit.dart';

abstract class BrandState extends Equatable {
  const BrandState();

  @override
  List<Object> get props => [];
}

class BrandListInitialState extends BrandState {}

class BrandListLoadingState extends BrandState {}

class BrandListErrorState extends BrandState {
  final String errorMessage;
  const BrandListErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class BrandListLoadedState extends BrandState {
  final List<BrandModel> brands;
  const BrandListLoadedState({required this.brands});

  @override
  List<Object> get props => [brands];
}
