part of 'list_product_bloc.dart';

@immutable
sealed class ListProductEvent {}

class GetListProductsEvent extends ListProductEvent {
  final GetListProductParams params;

  GetListProductsEvent(this.params);
}

class RefreshListProductEvent extends ListProductEvent {}
