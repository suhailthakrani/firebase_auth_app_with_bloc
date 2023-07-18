import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/bocs/signin/signin_bloc.dart';

import '../../repositories/auth_repository.dart';

part 'phone_event.dart';
part 'phone_state.dart';

class PhoneBloc extends Bloc<PhoneEvent, PhoneState> {
  final AuthRepository authRepository;
  PhoneBloc(this.authRepository) : super(PhoneInitialState()) {
    on<PhoneInitialEvent>(mapPhoneInitialEventWithState);
    on<PhoneTextFieldsChangedEvent>(mapPhoneTextfieldsChangedEventWithState);
    on<PhoneSendOtpButtonPressedEvent>(
        mapPhoneSendOtpButtonPressedEventWithState);
    on<PhoneVerifyOtpButtonPressedEvent>(
        mapPhoneVerifyOtpButtonPressedEventWithState);
    // on<PhoneContinueAsGuestPhoneEvent>(mapPhoneContinueAsGuestEventWithState);
  }

  Future<FutureOr<void>> mapPhoneSendOtpButtonPressedEventWithState(
      PhoneSendOtpButtonPressedEvent event, Emitter<PhoneState> emit) async {
    Map<String, String> errors = {};
    if (event.phone.isEmpty) {
      errors["email"] = "Please enter email";
    }
    if (errors.isNotEmpty) {
      emit(PhoneErrorState(errors: errors));
    } else {
      print("-----------------------1");

      authRepository.sendOtpOnPhone(phone: event.phone);
      emit(PhoneSuccessState());

      // emit(const PhoneInvalidCredentialState(error: "Please check your phone number!"));
    }
  }

  Future<FutureOr<void>> mapPhoneTextfieldsChangedEventWithState(
      PhoneTextFieldsChangedEvent event, Emitter<PhoneState> emit) async {
    Map<String, String> errors = {};

    if (event.phone.isEmpty) {
      errors["phone"] = "Please enter phone number";
    }
    if (event.phone.isEmpty) {
      errors["phone"] = "Please enter phone number";
    }
    if (errors.isNotEmpty) {
      emit(PhoneErrorState(errors: errors));
    } else {
      emit(PhoneSuccessState());
    }
  }

  FutureOr<void> mapPhoneInitialEventWithState(
      PhoneInitialEvent event, Emitter<PhoneState> emit) {
    try {
      emit(PhoneLoadingState());

      emit(PhoneSuccessState());
    } on Exception catch (e) {
      emit(PhoneErrorState(
        errors: {"other": "$e"},
      ));
    }
  }

  Future<FutureOr<void>> mapPhoneVerifyOtpButtonPressedEventWithState(
      PhoneVerifyOtpButtonPressedEvent event, Emitter<PhoneState> emit) async {
    try {
      emit(PhoneLoadingState());
      var vl = await authRepository.verifyOtp(smsCode: event.otp);
      if (vl == null ) {
        emit(PhoneNavigateState());
      } else{
         emit(PhoneErrorState(
        errors: {"error": "$vl"},
      ));
      }
    } on Exception catch (e) {
      emit(PhoneErrorState(
        errors: {"other": "$e"},
      ));
    }
  }
}
