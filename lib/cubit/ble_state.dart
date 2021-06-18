part of 'ble_cubit.dart';

@immutable
abstract class BleState {}

class BleInitial extends BleState {}

class SearchLoading extends BleState {}

class ReceiveCharSuccess extends BleState {}

class SearchCompleted extends BleState {
  final list;

  SearchCompleted({@required this.list});
}
