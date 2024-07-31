import 'package:cubit_avadhesh/bloc/ui/counter_page.dart';
import 'package:cubit_avadhesh/cubit/ui/list/list_exam.dart';
import 'package:cubit_avadhesh/cubit/ui/list/list_exam1.dart';
import 'package:cubit_avadhesh/cubit/ui/plat.dart';
import 'package:cubit_avadhesh/cubit/ui/tabBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late List<Widget> _children;
  final Key keyOne = const PageStorageKey("IndexTabWidget");

  @override
  void initState() {
    _children = [
      MyStatefulWidget(),
      MyStatefulWidget()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyApp.appName'),
        // titleTextStyle: Theme.of(context).textTheme.apply(
        //   bodyColor: Colors.black,
        //   displayColor: Colors.blue,
        // ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: Tabbar( screens: const [MyStatefulWidget(),MyStatefulWidget1()]),
    );
  }


}
