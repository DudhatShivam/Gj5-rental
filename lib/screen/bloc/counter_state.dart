part of 'counter_bloc.dart';

 class  CounterState extends Equatable {
  final List<DataModel> datamodel;

  const CounterState({required this.datamodel});

  @override
  List<Object> get props => [datamodel];
}

class CounterInitial extends CounterState {
  CounterInitial({required super.datamodel});
}
