part of 'checkbox_cart_cubit.dart';

class CartStatusState {
  final int id;
  bool status;
  final int branchId;

  CartStatusState({required this.id, required this.status, required this.branchId});
}

class CartBranchGroup {
  final int branchId;
  bool isGroupSelected;
  final List<CartStatusState> items;

  CartBranchGroup({required this.branchId, required this.isGroupSelected, required this.items});
}
//
// abstract class CheckboxCartState extends Equatable {
//   final List<CartStatusState> itemStates;
//   final bool isAllSelected;
//
//   const CheckboxCartState({required this.itemStates, required this.isAllSelected});
//
//   @override
//   List<Object> get props => [itemStates, isAllSelected];
// }
//
// class CheckboxCartInitial extends CheckboxCartState {
//   const CheckboxCartInitial({required super.itemStates, required super.isAllSelected});
//
//   CheckboxCartInitial copyWith({List<CartStatusState>? itemStates, bool? isAllSelected}) {
//     return CheckboxCartInitial(
//       itemStates: itemStates ?? this.itemStates,
//       isAllSelected: isAllSelected ?? this.isAllSelected,
//     );
//   }
// }

abstract class CheckboxCartState extends Equatable {
  final List<CartBranchGroup> branchGroups;
  final bool isAllSelected;

  const CheckboxCartState({
    required this.branchGroups,
    required this.isAllSelected
  });

  @override
  List<Object> get props => [branchGroups, isAllSelected];
}

class CheckboxCartInitial extends CheckboxCartState {
  const CheckboxCartInitial({
    required super.branchGroups,
    required super.isAllSelected
  });

  CheckboxCartInitial copyWith({
    List<CartBranchGroup>? branchGroups,
    bool? isAllSelected
  }) {
    return CheckboxCartInitial(
      branchGroups: branchGroups ?? this.branchGroups,
      isAllSelected: isAllSelected ?? this.isAllSelected,
    );
  }
}
