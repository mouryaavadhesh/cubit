import 'package:bloc/bloc.dart';
import 'package:cubit_avadhesh/list_state/cubit.dart';
import 'package:cubit_avadhesh/list_state/list_state.dart';
import 'package:cubit_avadhesh/repo/list_repo.dart';
import 'package:cubit_avadhesh/repo/repo_ex.dart';
import 'package:flutter/services.dart';

class ListCubit extends Cubit<CubitState> {
  final ListRepo _listRepo = ListRepo();
  static const platform = MethodChannel('samples.flutter.dev/battery');
  String _batteryLevel = 'Unknown battery level.';

  ListCubit() : super(InitTodoState()) {
    init();
  }

  void init() {
    fetchDataList();
  }
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

      _batteryLevel = batteryLevel;
    print(_batteryLevel);
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
