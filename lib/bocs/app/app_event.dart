// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object> get props => [];
}
class AppInitialEvent extends AppEvent {
  const AppInitialEvent(
  );

  @override
  List<Object> get props => [];
}

class AppSignOutEvent extends AppEvent {
  final BuildContext context;
  const AppSignOutEvent(
    this.context,
  );

  @override
  List<Object> get props => [context];
}
