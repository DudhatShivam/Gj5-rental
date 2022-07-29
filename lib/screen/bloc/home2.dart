import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gj5_rental/Utils/utils.dart';
import 'package:gj5_rental/block2/counter_bloc.dart';

import 'counter_home.dart';

class Home2 extends StatelessWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.read<CounterBloc>().add(clear(dataModelList: []));
            pushMethod(context, CounterHome());
          },
          child: Text("PUSH"),
        ),
      ),
    );
  }
}
