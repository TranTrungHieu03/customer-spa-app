part of 'list_category_bloc.dart';

@immutable
sealed class ListCategoryEvent {}

class GetListCategoriesEvent extends ListCategoryEvent {}
