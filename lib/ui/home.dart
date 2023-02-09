import 'package:cubit_avadhesh/ui/list/list_exam.dart';
import 'package:cubit_avadhesh/ui/list/list_exam1.dart';
import 'package:cubit_avadhesh/ui/main.dart';
import 'package:cubit_avadhesh/ui/plat.dart';
import 'package:cubit_avadhesh/ui/tabBar.dart';
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
      const MyStatefulWidget(),
      const MyStatefulWidget()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyApp.appName'),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.blue,
        ),
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: Tabbar( screens: const [PlatformChannel(),MyStatefulWidget1()]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Column buildButtonColumn(IconData icon) {
    Color color = Theme.of(context).primaryColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
      ],
    );
  }
}
