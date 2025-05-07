part of 'list_product_branch_bloc.dart';

@immutable
sealed class ListProductBranchEvent {}

final class GetListProductBranchEvent extends ListProductBranchEvent {
  final GetBranchHasProductParams params;

  GetListProductBranchEvent(this.params);
}
