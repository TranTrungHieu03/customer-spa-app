part of 'branch_bloc.dart';

@immutable
sealed class BranchEvent {}

class GetBranchDetailEvent extends BranchEvent {
  final GetBranchDetailParams params;

  GetBranchDetailEvent(this.params);
}

class RefreshBranchEvent extends BranchEvent {}