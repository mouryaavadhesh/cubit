import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cubit_avadhesh/cubit/model/data.dart';
import 'package:http/http.dart';

class Api {
  Future<Response> fetchData() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/albums');
    return await http.get(url);
  }
}
