
import 'package:cubit_avadhesh/list_state/cubit.dart';
import 'package:cubit_avadhesh/model/data.dart';

abstract class ListState extends CubitState{}

class InitTodoState extends ListState{}

class LoadingTodoState extends ListState{}

class ErrorTodoState extends ListState{
  final String error;
  ErrorTodoState(this.error);
}

class ResponseTodoState extends ListState{

  final List<Data> data;
  ResponseTodoState(this.data);
}