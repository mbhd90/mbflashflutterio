import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/error/failure.dart';
import '../../../profile/model/country_model.dart';
import '../../../profile/model/user_with_country_response.dart';
import '../../../profile/controllers/repository/profile_repository.dart';
import '../../models/auth_error_model.dart';
import '../../models/user_login_response_model.dart';
import '../../repository/auth_repository.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginModelState> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  final formKey = GlobalKey<FormState>();

  final List<CountryModel> countries = [];

  UserLoginResponseModel? _user;

  bool get isLogedIn => _user != null && _user!.accessToken.isNotEmpty;

  UserLoginResponseModel? get userInfo => _user;

  set user(UserLoginResponseModel userData) => _user = userData;

  LoginBloc({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  })  : _authRepository = authRepository,
        _profileRepository = profileRepository,
        super(const LoginModelState()) {
    on<LoginEvenEmailOrPhone>((event, emit) {
      emit(state.copyWith(text: event.text));
    });
    on<LoginEventPassword>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<LoginEventSubmit>(_submitLoginForm);
    on<SentAccountActivateCodeSubmit>(_sentAccountActivateCode);
    on<AccountActivateCodeSubmit>(_accountActivateCode);
    on<LoginEventLogout>(_logOut);
    on<LoginEventCheckProfile>(_getUserInfo);

    /// set user data if usre already login

    final result = _authRepository.getCashedUserInfo();

    result.fold(
      (l) => _user = null,
      (r) {
        user = r;
      },
    );
  }

  Future<void> _getUserInfo(
    LoginEventCheckProfile event,
    Emitter<LoginModelState> emit,
  ) async {
    final result = _authRepository.getCashedUserInfo();

    result.fold(
      (l) => _user = null,
      (r) {
        user = r;
        emit(state.copyWith(state: LoginStateLoaded(r)));
      },
    );

    ///load user info if user loged in and update user on bloc state
    if (isLogedIn) {
      final updateProfile =
          await _profileRepository.userProfile(userInfo!.accessToken);

      updateProfile.fold(
        (failure) {
          if (failure.statusCode == 401) {
            final currentState = LoginStateLogOut(
                'Session expired, Sign-in again', failure.statusCode);
            emit(state.copyWith(state: currentState));
          } else {
            final currentState =
                LoginStateError(failure.message, failure.statusCode);
            emit(state.copyWith(state: currentState));
          }
        },
        (UserWithCountryResponse userCountry) {
          user = (_user?.copyWith(user: userCountry.user))!;
          countries.clear();
          countries.addAll(userCountry.countries);
          emit(state.copyWith(state: LoginStateUpdatedProfile(userInfo!)));
        },
      );
    } else {
      _user = null;
      const currentState = LoginStateInitial();
      emit(state.copyWith(state: currentState));
    }
  }

  Future<void> _submitLoginForm(
    LoginEventSubmit event,
    Emitter<LoginModelState> emit,
  ) async {
    if (!formKey.currentState!.validate()) return;

    emit(state.copyWith(state: const LoginStateLoading()));
    final bodyData = state.toMap();

    final result = await _authRepository.login(bodyData);

    result.fold(
      (failure) {
        if (failure is InvalidAuthData) {
          final errors = LoginStateFormInvalid(failure.errors);
          emit(state.copyWith(state: errors));
        } else {
          final error = LoginStateError(failure.message, failure.statusCode);
          emit(state.copyWith(state: error));
        }
      },
      (user) {
        final loadedData = LoginStateLoaded(user);
        _user = user;
        emit(state.copyWith(state: loadedData));

        emit(state.copyWith(
          text: '',
          password: '',
          state: const LoginStateInitial(),
        ));
      },
    );
  }

  Future<void> _sentAccountActivateCode(
    SentAccountActivateCodeSubmit event,
    Emitter<LoginModelState> emit,
  ) async {
    emit(state.copyWith(state: const LoginStateLoading()));

    final result = await _authRepository.sendActiveAccountCode(state.text);

    result.fold(
      (Failure failure) {
        final error = LoginStateError(failure.message, failure.statusCode);
        emit(state.copyWith(state: error));
      },
      (String success) {
        //Firebase auth version//

        //FIN
        final loadedData = SendAccountCodeSuccess(success);
        emit(state.copyWith(state: loadedData));
      },
    );
  }

  Future<void> _accountActivateCode(
    AccountActivateCodeSubmit event,
    Emitter<LoginModelState> emit,
  ) async {
    emit(state.copyWith(state: const LoginStateLoading()));

    final result = await _authRepository.activeAccountCodeSubmit(event.code);

    result.fold(
      (Failure failure) {
        final error = LoginStateError(failure.message, failure.statusCode);
        emit(state.copyWith(state: error));
      },
      (String success) {
        final loadedData = AccountActivateSuccess(success);
        emit(state.copyWith(state: loadedData));
      }, /*
      (user) {
        final loadedData = LoginStateLoaded(user);
        _user = user;
        emit(state.copyWith(state: loadedData));

        emit(state.copyWith(
          text: '',
          password: '',
          state: const LoginStateInitial(),
        ));
      },*/
    );
  }

  Future<void> _logOut(
    LoginEventLogout event,
    Emitter<LoginModelState> emit,
  ) async {
    emit(state.copyWith(state: const LoginStateLogOutLoading()));

    final result = await _authRepository.logOut(userInfo!.accessToken);

    result.fold(
      (Failure failure) {
        if (failure.statusCode == 500) {
          const loadedData = LoginStateLogOut('logout success', 200);
          emit(state.copyWith(state: loadedData));
        } else {
          final error =
              LoginStateSignOutError(failure.message, failure.statusCode);
          emit(state.copyWith(state: error));
        }
      },
      (String success) {
        _user = null;
        final loadedData = LoginStateLogOut(success, 200);
        emit(state.copyWith(state: loadedData));
      },
    );
  }
}
