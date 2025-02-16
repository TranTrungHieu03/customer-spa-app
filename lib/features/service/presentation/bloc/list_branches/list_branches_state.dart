part of 'list_branches_bloc.dart';

@immutable
sealed class ListBranchesState {}

final class ListBranchesInitial extends ListBranchesState {}

final class ListBranchesLoading extends ListBranchesState {}

final class ListBranchesError extends ListBranchesState {
  final String message;

  ListBranchesError(this.message);
}

final class ListBranchesEmpty extends ListBranchesState {}

final class ListBranchesLoaded extends ListBranchesState {
  final List<BranchModel> branches;

  ListBranchesLoaded(this.branches);
}
