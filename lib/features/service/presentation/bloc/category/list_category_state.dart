part of 'list_category_bloc.dart';

@immutable
sealed class ListCategoryState {}

final class ListCategoryInitial extends ListCategoryState {}

class ListCategoryLoading extends ListCategoryState {}
class ListCategoryEmpty extends ListCategoryState {}

class ListCategoryLoaded extends ListCategoryState {
  final List<CategoryModel> categories;

  ListCategoryLoaded(this.categories);
}

class ListCategoryError extends ListCategoryState {
  final String message;

  ListCategoryError(this.message);
}
