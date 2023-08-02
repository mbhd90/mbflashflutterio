import 'package:bm_flash/modules/search/model/search_response_model.dart';
import 'package:dartz/dartz.dart';
import '/modules/home/model/product_model.dart';
import '../../../../core/data/datasources/remote_data_source.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../model/home_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeModel>> getHomeData();
  Future<Either<Failure, SearchResponseModel>> getHighlightProducts(
      String keyword, int page, int perPage);

  Future<Either<Failure, SearchResponseModel>> loadMoreProducts(
      String keyword, int page, int perPage);
}

class HomeRepositoryImp extends HomeRepository {
  final RemoteDataSource remoteDataSource;
  HomeRepositoryImp({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomeModel>> getHomeData() async {
    try {
      final result = await remoteDataSource.getHomeData();
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, SearchResponseModel>> getHighlightProducts(
      String keyword, int page, int perPage) async {
    try {
      final result = await remoteDataSource.getHighlightProducts(keyword, page, perPage);
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, SearchResponseModel>> loadMoreProducts(String keyword, int page, int perPage) async {
    try {
      final result = await remoteDataSource.loadMoreProducts(keyword, page,perPage);
      return right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
