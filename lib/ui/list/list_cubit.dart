import 'package:bloc/bloc.dart';
import 'package:cubit_avadhesh/list_state/list_state.dart';
import 'package:cubit_avadhesh/repo/list_repo.dart';
import 'package:cubit_avadhesh/repo/repo_ex.dart';

class ListCubit extends Cubit<ListState> {
  final ListRepo _listRepo = ListRepo();

  ListCubit() : super(InitTodoState()) {
    init();
  }

  void init() {
    fetchDataList();
  }

  Future<bool> onBackPress() {
    // TODO: implement onBackPress
    throw UnimplementedError();
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
