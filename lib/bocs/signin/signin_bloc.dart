import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository authRepository;
  SignInBloc(this.authRepository) : super(SignInInitialState()) {
    on<SignInInitialEvent>(mapSignInInitialEventWithState);
    // on<SignInShowOrHidePasswordEvent>(mapSignInShowOrHidePasswordEventTOState);
    on<SignInTextFieldsChangedEvent>(mapSignInTextfieldsChangedEventWithState);
    on<SignInButtonPressedeEvent>(mapSignInButtonPressedEventWithState);
  }

  Future<FutureOr<void>> mapSignInButtonPressedEventWithState(
      SignInButtonPressedeEvent event, Emitter<SignInState> emit) async {
    Map<String, String> errors = {};

    
      if (event.email.isEmpty) {
        errors["email"] = "Please enter email";
      }
      if (event.password.isEmpty) {
        errors["password"] = "Please enter password";
      }
      if (errors.isNotEmpty) {
        emit(SignInErrorState(errors: errors));
      } else {
        print("-----------------------1");
        User? user = await authRepository.signInWithEmail(
            email: event.email, password: event.password);
        print("-----------------------2");
        if (user != null) {
          emit(SignInNavigateState());
        } else {
          
          emit(const SignInInvalidCredentialState(error: "Please check your password or email!")); 
        }
      }
    
  }

  Future<FutureOr<void>> mapSignInTextfieldsChangedEventWithState(
      SignInTextFieldsChangedEvent event, Emitter<SignInState> emit) async {
    Map<String, String> errors = {};

    if (event.email.isEmpty) {
      errors["email"] = "Please enter email";
    } else if (event.password.isEmpty) {
      errors["password"] = "Please enter password";
    }
    if (errors.isNotEmpty) {
      emit(SignInErrorState(errors: errors));
    } else {
      emit(SignInSuccessState());
    }
  }

  FutureOr<void> mapSignInInitialEventWithState(
      SignInInitialEvent event, Emitter<SignInState> emit) {
    try {
      emit(SignInLoadingState());

      emit(SignInSuccessState());
    } on Exception catch (e) {
      emit(SignInErrorState(
        errors: {"other": "$e"},
      ));
    }
  }


}
