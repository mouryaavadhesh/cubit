

import 'dart:convert';

import 'package:cubit_avadhesh/services/api.dart';
import 'package:cubit_avadhesh/base/enum_data_state.dart';
import 'package:cubit_avadhesh/repo/repo_response.dart';
import 'package:cubit_avadhesh/model/data.dart';

class ListRepo extends Api{
  
  
  Future<RepoResponse<List<Data>>> getList() async {
    return await fetchData().then((value) {
      switch (value.statusCode) {
        case 200:
          List jsonResponse = json.decode(value.body);
          var data=  jsonResponse.map((data) => Data.fromJson(data)).toList();
          return SuccessResponse(data);
        default:
          return FailedResponse(DataErrorState.noData);
      }
    });
  }

}