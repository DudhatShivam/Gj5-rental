import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../screen/demoqty_model.dart';

part 'counter_event.dart';

part 'counter_state.dart';

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitial(datamodel: [])) {
    on<increment>((event, emit) {
      emit(CounterState(
          datamodel: List.from(state.datamodel)..addAll(event.dataModelList)));
    });
    on<clear>((event, emit) {
      emit(CounterState(datamodel: event.dataModelList));
    });
  }
}
