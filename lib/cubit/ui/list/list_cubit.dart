import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cubit_avadhesh/cubit/list_state/cubit.dart';
import 'package:cubit_avadhesh/cubit/list_state/list_state.dart';
import 'package:cubit_avadhesh/cubit/model/contacts_model.dart';
import 'package:flutter/services.dart';

class ListCubit extends Cubit<CubitState> {

  static String ava="avadhesh";
   String ava1="avadhesh";

  static const MethodChannel methodChannelContact =
      MethodChannel('samples.flutter.io/contact');

  ListCubit() : super(InitTodoState()) {
    init();
  }

  void init() {

  }

  Future<void> getContact() async {
    emit(LoadingTodoState());
    await methodChannelContact
        .invokeMethod('getContact')
        .then((value) {
      dynamic list = value;
      var data = json.decode(jsonEncode(list));
      var rest = data as List;

      List<ContactsModel>   listContacts = rest.map<ContactsModel>((json) => ContactsModel.fromJson(json)).toList();
      emit(ResponseContactState(listContacts));
    } );

  }
  Uint8List convertBase64Image(String base64String) {
    return const Base64Decoder().convert(base64String.split(',').last);
  }
  Future<void> onRefresh() async {}


}
