part of 'list_product_bloc.dart';

@immutable
sealed class ListProductState {
  const ListProductState();
}

final class ListProductInitial extends ListProductState {}

final class ListProductLoading extends ListProductState {
  final bool isLoadingMore;

  const ListProductLoading({this.isLoadingMore = false});
}

final class ListProductLoaded extends ListProductState {
  final List<ProductModel> products;
  final PaginationModel pagination;
  final bool isLoadingMore;

  const ListProductLoaded({
    required this.products,
    required this.pagination,
    this.isLoadingMore = false,
  });

  ListProductLoaded copyWith({
    List<ProductModel>? products,
    PaginationModel? pagination,
    bool? isLoadingMore,
  }) {
    return ListProductLoaded(
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

final class ListProductFailure extends ListProductState {
  final String message;

  const ListProductFailure(this.message);
}

final class ListProductEmpty extends ListProductState {}
