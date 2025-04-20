part of 'service_categories_bloc.dart';

@immutable
sealed class ServiceCategoriesState {}

final class ServiceCategoriesInitial extends ServiceCategoriesState {}

final class ServiceCategoriesLoading extends ServiceCategoriesState {}

final class ServiceCategoriesLoaded extends ServiceCategoriesState {
  final List<CategoryModel> categories;

  ServiceCategoriesLoaded(this.categories);
}

final class ServiceCategoriesError extends ServiceCategoriesState {
  final String message;

  ServiceCategoriesError(this.message);
}
