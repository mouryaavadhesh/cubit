import 'package:cubit_avadhesh/services/api.dart';
import 'package:cubit_avadhesh/list_state/list_state.dart';
import 'package:cubit_avadhesh/ui/list/list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  void intiState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final cubit = context.read<ListCubit>();
      cubit.fetchDataList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (BuildContext context) => ListCubit(),
        child: BlocBuilder<ListCubit, ListState>(
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
    );
  }
}
