part of 'product_categories_bloc.dart';

@immutable
sealed class ProductCategoriesState {}

final class ProductCategoriesInitial extends ProductCategoriesState {}

final class ProductCategoriesLoading extends ProductCategoriesState {}

final class ProductCategoriesLoaded extends ProductCategoriesState {
  final List<ProductCategoryModel> categories;

  ProductCategoriesLoaded(this.categories);
}

final class ProductCategoriesError extends ProductCategoriesState {
  final String message;

  ProductCategoriesError(this.message);
}
