part of 'branch_bloc.dart';

@immutable
sealed class BranchState {}

final class BranchInitial extends BranchState {}
final class BranchLoading extends BranchState {}
final class BranchLoaded extends BranchState {
  final BranchModel branchModel;
  BranchLoaded(this.branchModel);
}
final class BranchError extends BranchState {
  final String message;
  BranchError(this.message);
}
