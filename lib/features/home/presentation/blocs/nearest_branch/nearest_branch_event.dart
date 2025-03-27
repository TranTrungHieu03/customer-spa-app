part of 'nearest_branch_bloc.dart';

@immutable
sealed class NearestBranchEvent {}

class GetNearestBranchEvent extends NearestBranchEvent {
  final GetDistanceParams params;
  final bool isFirst;

  GetNearestBranchEvent({required this.params, this.isFirst = false});
}
