import 'package:bloc/bloc.dart';
import 'package:cubit_avadhesh/cubit/list_state/cubit.dart';
import 'package:cubit_avadhesh/cubit/list_state/list_state.dart';
import 'package:cubit_avadhesh/cubit/repo/list_repo.dart';
import 'package:cubit_avadhesh/cubit/repo/repo_ex.dart';
import 'package:flutter/services.dart';

class ListCubit1 extends Cubit<CubitState> {
  final ListRepo _listRepo = ListRepo();

  ListCubit1() : super(InitTodoState()) {
    init();
  }

  void init() {
    fetchDataList();
  }

  Future<void> onRefresh() async {}

  fetchDataList() {
    emit(LoadingTodoState());
    _listRepo.getList().thenListenData(
          onSuccess: (response) => {
            emit(ResponseTodoState(response)),
          },
        );
  }
}
