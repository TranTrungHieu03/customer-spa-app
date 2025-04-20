part of 'product_categories_bloc.dart';

@immutable
sealed class ProductCategoriesEvent {}
final class GetProductCategoriesEvent extends ProductCategoriesEvent {
  GetProductCategoriesEvent();
}
