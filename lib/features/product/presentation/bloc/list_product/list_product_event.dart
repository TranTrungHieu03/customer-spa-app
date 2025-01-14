part of 'list_product_bloc.dart';

@immutable
sealed class ListProductEvent {}

class GetListProductsEvent extends ListProductEvent {
  final int page;

  GetListProductsEvent(this.page);
}
