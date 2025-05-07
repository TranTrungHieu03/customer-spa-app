part of 'list_product_branch_bloc.dart';

@immutable
sealed class ListProductBranchState {}

final class ListProductBranchInitial extends ListProductBranchState {}

final class ListProductBranchLoading extends ListProductBranchState {}

final class ListProductBranchLoaded extends ListProductBranchState {
  final List<ProductBranchModel> products;

  ListProductBranchLoaded(this.products);
}

final class ListProductBranchError extends ListProductBranchState {
  final String message;

  ListProductBranchError(this.message);
}
