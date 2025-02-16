part of 'list_branches_bloc.dart';

@immutable
sealed class ListBranchesEvent {}

final class GetListBranchesEvent extends ListBranchesEvent {}