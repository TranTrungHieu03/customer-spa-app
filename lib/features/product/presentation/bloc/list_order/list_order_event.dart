part of 'list_order_bloc.dart';

@immutable
sealed class ListOrderEvent {
  final int page;
  final String title;

  const ListOrderEvent({required this.page, required this.title});
}

class GetListOrderEvent extends ListOrderEvent {
  GetListOrderEvent({required super.page, required super.title});
}
