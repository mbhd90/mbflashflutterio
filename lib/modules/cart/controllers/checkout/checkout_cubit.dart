import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../authentication/controller/login/login_bloc.dart';
import '../../model/checkout_response_model.dart';
import '../cart_repository.dart';
import '/utils/language_string.dart';

part 'checkout_state.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  final CartRepository _cartRepository;

  final LoginBloc _loginBloc;
  CheckoutCubit({
    required LoginBloc loginBloc,
    required CartRepository cartRepository,
  })  : _cartRepository = cartRepository,
        _loginBloc = loginBloc,
        super(const CheckoutStateInitial());

   CheckoutResponseModel? checkoutResponseModel;

  Future<void> getCheckOutData(String couponCode) async {
    if (_loginBloc.userInfo == null) {
      emit(CheckoutStateError(Language.pleaseLoginFirst, 401));
      return;
    }

    emit(const CheckoutStateLoading());
    final result = await _cartRepository.getCheckoutData(
        _loginBloc.userInfo!.accessToken, couponCode);

    result.fold(
      (failure) {
        emit(CheckoutStateError(failure.message, failure.statusCode));
      },
      (successData) {
        checkoutResponseModel = successData;
        emit(CheckoutStateLoaded(successData));
      },
    );
  }
}
