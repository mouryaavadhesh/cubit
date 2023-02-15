import 'dart:convert';
import 'dart:typed_data';

import 'package:cubit_avadhesh/list_state/cubit.dart';
import 'package:cubit_avadhesh/list_state/list_state.dart';
import 'package:cubit_avadhesh/ui/list/list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  void intiState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Contact List Via Channel'),
        ),
        body: SingleChildScrollView(
          child: BlocProvider(
            create: (BuildContext context) => ListCubit(),
            child: BlocBuilder<ListCubit, CubitState>(
              builder: (context, state) {
                if (state is InitTodoState || state is LoadingTodoState) {
                  return InkWell(
                      onTap: () {
                        context.read<ListCubit>().getContact();
                      }, child: const Center(child: Text('No Data')));
                } else if (state is ResponseContactState) {
                  final contact = state.contactList;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: contact.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: const EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(10.0),
                          color: Colors.blue.shade100,
                          child: Column(
                            children: [
                              Text(
                                contact[index].name!,
                                style: const TextStyle(fontSize: 10),
                              ),
                              contact[index].photo!.isNotEmpty? Image.memory(Uint8List.fromList(contact[index].photo!)):const Icon(Icons.ice_skating,size: 50,color: Colors.red,)
                            ],
                          ),
                        );
                      });
                } else if (state is ErrorTodoState) {
                  return const Center(child: Text('No Data'));
                }
                return Center(child: Text(state.toString()));
              },
            ),
          ),
        ),
      ),
    );
  }
}
