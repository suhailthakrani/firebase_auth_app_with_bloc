// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'phone_bloc.dart';

abstract class PhoneEvent extends Equatable {
  const PhoneEvent();

  @override
  List<Object> get props => [];
}

class PhoneInitialEvent extends PhoneEvent {
  @override
  List<Object> get props => [];
}

class PhoneTextFieldsChangedEvent extends PhoneEvent {
  final String phone;
  const PhoneTextFieldsChangedEvent({
    required this.phone,
  });
  @override
  List<Object> get props => [phone];
}

class PhoneSendOtpButtonPressedEvent extends PhoneEvent {
  final String phone;
  const PhoneSendOtpButtonPressedEvent({
    required this.phone,
  });
  @override
  List<Object> get props => [phone];
}

class PhoneVerifyOtpButtonPressedEvent extends PhoneEvent {
  final String otp;
  const PhoneVerifyOtpButtonPressedEvent({
    required this.otp,
  });
  @override
  List<Object> get props => [otp];
}
