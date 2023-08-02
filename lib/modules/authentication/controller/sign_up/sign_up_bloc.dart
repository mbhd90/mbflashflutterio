// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import '../../../../core/error/failure.dart';
import '../../models/auth_error_model.dart';
import '../../repository/auth_repository.dart';
import '../../../../utils/language_string.dart';
part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpModelState> {
  final AuthRepository repository;
  //final formKey = GlobalKey<FormState>();
  SignUpBloc(this.repository) : super(const SignUpModelState()) {
    on<SignUpEventName>((event, emit) {
      emit(state.copyWith(name: event.name));
    });
    on<SignUpEventEmail>((event, emit) {
      emit(state.copyWith(email: event.email));
    });
    on<SignUpEventPhone>((event, emit) {
      emit(state.copyWith(phone: event.phone));
    });
    on<SignUpEventPhoneCode>((event, emit) {
      emit(state.copyWith(phoneCode: event.code));
    });
    on<SignUpEventPassword>((event, emit) {
      emit(state.copyWith(password: event.password));
    });
    on<SignUpEventPasswordConfirm>((event, emit) {
      emit(state.copyWith(passwordConfirmation: event.passwordConfirm));
    });
    on<SignUpEventAgree>((event, emit) {
      emit(state.copyWith(agree: event.agree));
    });
    on<SignUpEventSubmit>(_submitForm);
  }
  void _submitForm(
      SignUpEventSubmit event, Emitter<SignUpModelState> emit) async {
    //if (!formKey.currentState!.validate()) return;

    if (state.agree == 0) {
      var stateError =
          SignUpStateFormError(Language.pleaseAgreeWithPrivacyPolic);
      emit(state.copyWith(state: const SignUpStateInitial()));
      emit(state.copyWith(state: stateError));
      return;
    }
    emit(state.copyWith(state: const SignUpStateLoading()));
    final bodyData = state.toMap();
    log(bodyData.toString(), name: "SignUp Data");
    print("SignUp Data");
    print(bodyData);

    final result = await repository.signUp(bodyData);

    result.fold(
      (failure) {
        if (failure is InvalidAuthData) {
          print("failure == ");
          print(failure.errors);
          final errors = SignUpStateLoadedError(failure.errors);
          emit(state.copyWith(state: errors));
        } else {
          print("failure == ");
          print(failure);
          // final data = failure['notification'];
          log(failure.errors.toString(), name: "SignUpBloc Error");
          final error = SignUpStateFormError(failure.errors);
          emit(state.copyWith(state: error));
        }
      },
      (user) {
        print("user == ");
        print(user);
        log(user.toString(), name: "SignUpBloc Success");
        emit(state.copyWith(state: SignUpStateLoaded(user)));
      },
    );
  }
}
