import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../authentication/controller/login/login_bloc.dart';
import '../payment_repository.dart';
part 'bank_state.dart';

class BankCubit extends Cubit<BankState> {
  final PaymentRepository _paymentRepository;

  final LoginBloc _loginBloc;

  BankCubit({
    required LoginBloc loginBloc,
    required PaymentRepository paymentRepository,
  })  : _paymentRepository = paymentRepository,
        _loginBloc = loginBloc,
        super(const BankInitialState());

  Future<void> makeBankPayment(Map<String, String> body) async {
    emit(const BankStateLoading());
    final result = await _paymentRepository.bankPay(
        _loginBloc.userInfo!.accessToken, body);

    result.fold((failure) {
      emit(BankStateError(failure.message, failure.statusCode));
    }, (data) {
      emit(BankLoadedState(data));
    });
  }
}
