import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_app/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitialState()) {
     on<AppInitialEvent>(mapAppInitialEventtWithState);
    on<AppSignOutEvent>(mapAppSignOutEventWithState);
  }

  Future<FutureOr<void>> mapAppSignOutEventWithState(AppSignOutEvent event, Emitter<AppState> emit) async {
    final AuthRepository authRepository = AuthRepository();
    final User? user = await authRepository.signOut();

    
      emit(AppNavigateState());
  

  }

  FutureOr<void> mapAppInitialEventtWithState(AppInitialEvent event, Emitter<AppState> emit) {
    emit(AppInitialState());
  }
}
