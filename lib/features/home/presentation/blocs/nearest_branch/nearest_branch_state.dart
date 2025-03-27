part of 'nearest_branch_bloc.dart';

@immutable
sealed class NearestBranchState {}

final class NearestBranchInitial extends NearestBranchState {}

final class NearestBranchLoaded extends NearestBranchState {
  final List<BranchDistanceModel> branches;
  final BranchDistanceModel nearestBranch;

  NearestBranchLoaded({required this.branches, required this.nearestBranch});
}

final class NearestBranchLoading extends NearestBranchState {}

final class NearestBranchError extends NearestBranchState {
  final String message;

  NearestBranchError(this.message);
}
