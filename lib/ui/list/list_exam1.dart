import 'package:cubit_avadhesh/list_state/cubit.dart';
import 'package:cubit_avadhesh/list_state/list_state.dart';
import 'package:cubit_avadhesh/ui/list/list_cubit1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyStatefulWidget1 extends StatefulWidget {
  const MyStatefulWidget1({Key? key}) : super(key: key);


  @override
  State<MyStatefulWidget1> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget1> {
  @override
  void intiState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<ListCubit1>();
      cubit.fetchDataList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('List Cubit Example'),),
        body: BlocProvider(
          create: (BuildContext context) => ListCubit1(),
          child: BlocBuilder<ListCubit1, CubitState>(
            builder: (context, state) {
              if (state is InitTodoState || state is LoadingTodoState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ResponseTodoState) {
                final todos=state.data;
                return ListView.builder(
                    itemCount: todos.length ,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.blue.shade100,
                        child:  Center(
                          child: Text(
                            todos[index].title,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ),
                      );
                    });
              }else if (state is ErrorTodoState) {
                return  const Center(child: Text('No Data'));
              } return  Center(child: Text(state.toString()));
            },
          ),
        ),
      ),
    );
  }
}
