
import 'package:cubit_avadhesh/list_state/cubit.dart';
import 'package:cubit_avadhesh/model/contacts_model.dart';
import 'package:cubit_avadhesh/model/data.dart';

abstract class ListState extends CubitState{}

class InitTodoState extends CubitState{}

class LoadingTodoState extends CubitState{}

class ErrorTodoState extends CubitState{
  final String error;
  ErrorTodoState(this.error);
}

class ResponseTodoState extends CubitState{

  final List<Data> data;
  ResponseTodoState(this.data);
}

class ResponseContactState extends CubitState{

  final List<ContactsModel> contactList;
  ResponseContactState(this.contactList);
}