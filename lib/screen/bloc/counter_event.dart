part of 'counter_bloc.dart';

abstract class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class increment extends CounterEvent {
  final List<DataModel> dataModelList;

  increment({required this.dataModelList});

  @override
  // TODO: implement props
  List<Object?> get props => [dataModelList];
}

class clear extends CounterEvent {
  final List<DataModel> dataModelList;

  clear({required this.dataModelList});

  @override
  // TODO: implement props
  List<Object?> get props => [dataModelList];
}
