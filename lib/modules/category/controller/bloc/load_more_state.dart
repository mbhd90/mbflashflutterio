part of 'load_more_bloc.dart';

abstract class LoadMoreState extends Equatable {
  const LoadMoreState();

  @override
  List<Object> get props => [];
}

class LoadMoreLoadingState extends LoadMoreState {}

class LoadMoreLoadedState extends LoadMoreState {
  final List<ProductModel> products;
  const LoadMoreLoadedState({required this.products});

  @override
  List<Object> get props => [products];
}

class LoadMoreErrorState extends LoadMoreState {
  final String errorMessage;
  const LoadMoreErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}

class LoadMoreInitial extends LoadMoreState {}
