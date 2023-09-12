import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


abstract class _AppState extends Equatable {
}

class CubitState extends _AppState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

abstract class AppCubit<T> extends Cubit<T> {
  AppCubit(T initialState) : super(initialState);

  void init();

  Future<bool> onBackPress();

  Future<void> onRefresh();
}

