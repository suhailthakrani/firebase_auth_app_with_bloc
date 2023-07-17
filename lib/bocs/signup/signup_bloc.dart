import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth_app/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;
  bool showPass = false;
  SignUpBloc(this.authRepository) : super(SignUpInitialState()) {
    on<SignUpInitialEvent>(mapSignUpInitialEventWithState);
    on<SignUpTextFieldsChangedEvent>(mapSignUpTextFieldsChangedEventWithState);
    on<SignUpWithEmailButtonPressedEvent>(mapSignUpButtonPressedEventWithState);
    on<SignUpPhoneButtonPressedEvent>(mapSignUpPhoneButtonPressedEventWithState);
    on<SignUpGoogleButtonPressedEvent>(mapSignUpGoogleButtonPressedEventWithState);
    on<SignUpFacebookButtonPressedEvent>(mapSignUpFacebookButtonPressedEventWithState);
    on<SignUpHaveVisitWithoutSignUpEvent>(mapSignUpHaveVisitWithoutSignUpEventWithState);
    
  }
  Future<void> mapSignUpTextFieldsChangedEventWithState(
      SignUpTextFieldsChangedEvent event, Emitter<SignUpState> emit) async {
    Map<String, String> fieldErrors = <String, String>{};
    RegExp emailRegExp =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegExp.hasMatch(event.email)) {
      fieldErrors["email"] = "Please enter a valid email!";
    }
    if (event.name.isEmpty || event.name.length < 5) {
      fieldErrors["name"] = "Please enter a valid username!";
    }
    if (event.password.isEmpty ||
        event.password.length < 8) {
      fieldErrors["password"] =  "Password must be at least 8 characters long!";
    }
    if (event.password.compareTo(event.confrimPassword) != 0) {
      fieldErrors["confrimPassword"] =  "Passwords don't match!";
    }
    if (fieldErrors.isNotEmpty) {
      emit(SignUpErrorState(fieldErrors: fieldErrors));
    } else {
      emit(SignUpSuccessState());
    }
  }

  Future<void> mapSignUpButtonPressedEventWithState(
      SignUpWithEmailButtonPressedEvent event, Emitter<SignUpState> emit) async {
    Map<String, String> fieldErrors = <String, String>{};
    RegExp emailRegExp =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailRegExp.hasMatch(event.email)) {
      fieldErrors["email"] = "Please enter a valid email!";
    }
    if (event.name.isEmpty || event.name.length < 5) {
      fieldErrors["name"] = "Please enter a valid username!";
    }
    if (event.password.isEmpty ||
        event.password.length < 8) {
      fieldErrors["password"] =  "Password must be at least 8 characters long!";
    }
    if (event.password.compareTo(event.confrimPassword) != 0) {
      fieldErrors["confrimPassword"] =  "Passwords don't match!";
    }
    if (fieldErrors.isNotEmpty) {
      emit(SignUpErrorState(fieldErrors: fieldErrors));
    } else {
      emit(SignUpLoadingState());
      await authRepository.signUpWithEmail(email: event.email, password: event.password, name: event.name);
      emit(SignUpNavigateState());
    }
  }

  FutureOr<void> mapSignUpInitialEventWithState(
      SignUpInitialEvent event, Emitter<SignUpState> emit) {
    try {
      emit(SignUpLoadingState());

      emit(SignUpSuccessState());
    } on Exception catch (e) {
      emit(SignUpErrorState(
        fieldErrors: {"other": "$e"},
      ));
    }
  }

  FutureOr<void> mapSignUpPhoneButtonPressedEventWithState(SignUpPhoneButtonPressedEvent event, Emitter<SignUpState> emit) {
    emit(SignUpNavigateState());
  }

  FutureOr<void> mapSignUpGoogleButtonPressedEventWithState(SignUpGoogleButtonPressedEvent event, Emitter<SignUpState> emit) {
    emit(SignUpNavigateState());
  }

  FutureOr<void> mapSignUpFacebookButtonPressedEventWithState(SignUpFacebookButtonPressedEvent event, Emitter<SignUpState> emit) {
    emit(SignUpNavigateState());
  }

  FutureOr<void> mapSignUpHaveVisitWithoutSignUpEventWithState(SignUpHaveVisitWithoutSignUpEvent event, Emitter<SignUpState> emit) {
    emit(SignUpNavigateState());
  }
}
