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
    on<SignInWithEmailButtonPressedEvent>(mapSignInButtonPressedEventWithState);
    on<SignInGoogleButtonPressedEvent>(mapSignInGoogleButtonPressedEventWithState);
    on<SignInHaveVisitWithoutSignInEvent>(mapSignInHaveVisitWithoutSignInEventWithState);
    }

  Future<FutureOr<void>> mapSignInButtonPressedEventWithState(
      SignInWithEmailButtonPressedEvent event, Emitter<SignInState> emit) async {
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
        print("-----------------------2 $user");
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
   FutureOr<void> mapSignInPhoneButtonPressedEventWithState(SignInPhoneButtonPressedEvent event, Emitter<SignInState> emit) {
    emit(SignInNavigateState());
  }

  Future<FutureOr<void>> mapSignInGoogleButtonPressedEventWithState(SignInGoogleButtonPressedEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoadingState());
    await authRepository.continueWithGoogle();
    emit(SignInNavigateState());
  }

  FutureOr<void> mapSignInFacebookButtonPressedEventWithState(SignInFacebookButtonPressedEvent event, Emitter<SignInState> emit) {
    emit(SignInNavigateState());
  }

  Future<FutureOr<void>> mapSignInHaveVisitWithoutSignInEventWithState(SignInHaveVisitWithoutSignInEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoadingState());
    await authRepository.signInAnonymously();
    emit(SignInNavigateState());
  }

}
