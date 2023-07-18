part of 'phone_bloc.dart';

abstract class PhoneState extends Equatable {
  const PhoneState();
  
  @override
  List<Object> get props => [];
}

abstract class PhoneActionState extends PhoneState {
  const PhoneActionState();
  
  @override
  List<Object> get props => [];
}

class PhoneInitialState extends PhoneState {
    @override
  List<Object> get props => [];
}
class PhoneLoadingState extends PhoneState {
    @override
  List<Object> get props => [];
}
class SignOutState extends PhoneState {}
class PhoneSuccessState extends PhoneState {

    @override
  List<Object> get props => [];
}
class PhoneNavigateState extends PhoneState {

    @override
  List<Object> get props => [];
}
class PhoneErrorState extends PhoneState {
  final Map<String, String> errors;
  const PhoneErrorState({
    required this.errors,
  });
    @override
  List<Object> get props => [errors];
}
class PhoneInvalidCredentialState extends PhoneActionState {
  final String error;
  const PhoneInvalidCredentialState({
    required this.error,
  });
      @override
  List<Object> get props => [error];
}


