// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'signup_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpInitialEvent extends SignUpEvent {
  const SignUpInitialEvent();

  @override
  List<Object> get props => [];
}

class SignUpTextFieldsChangedEvent extends SignUpEvent {
  final String name;
  final String email;
  final String password;
  final String confrimPassword;

  const SignUpTextFieldsChangedEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.confrimPassword,
  });

  @override
  List<Object> get props => [name, email, password, confrimPassword];
}

class SignUpWithEmailButtonPressedEvent extends SignUpEvent {
  final String name;
  final String email;
  final String password;
  final String confrimPassword;
  const SignUpWithEmailButtonPressedEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.confrimPassword,
  });

  @override
  List<Object> get props => [email, password];
}

class SignUpHaveVisitWithoutSignUpEvent extends SignUpEvent {
  @override
  List<Object> get props => [];
}

class SignUpPhoneButtonPressedEvent extends SignUpEvent {
  @override
  List<Object> get props => [];
}

class SignUpGoogleButtonPressedEvent extends SignUpEvent {
  @override
  List<Object> get props => [];
}

class SignUpFacebookButtonPressedEvent extends SignUpEvent {
  @override
  List<Object> get props => [];
}
