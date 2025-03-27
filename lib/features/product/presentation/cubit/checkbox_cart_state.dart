part of 'checkbox_cart_cubit.dart';

class CartState {
  final int id;
  bool status;

  CartState({required this.id, required this.status});
}

// final class CheckboxCartInitial extends CheckboxCartState {
//   final CartState itemStates;
//   final bool isAllSelected;
//
//   CheckboxCartInitial({required this.itemStates, required this.isAllSelected});
//
//   CheckboxCartState copyWith({Map<String, bool>? itemStates, bool? isAllSelected}) {
//     return CheckboxCartInitial(itemStates: itemStates ?? this.itemStates, isAllSelected: isAllSelected ?? this.isAllSelected);
//   }
// }

abstract class CheckboxCartState extends Equatable {
  final List<CartState> itemStates;
  final bool isAllSelected;

  const CheckboxCartState({required this.itemStates, required this.isAllSelected});

  @override
  List<Object> get props => [itemStates, isAllSelected];
}

class CheckboxCartInitial extends CheckboxCartState {
  const CheckboxCartInitial({required super.itemStates, required super.isAllSelected});

  CheckboxCartInitial copyWith({List<CartState>? itemStates, bool? isAllSelected}) {
    return CheckboxCartInitial(
      itemStates: itemStates ?? this.itemStates,
      isAllSelected: isAllSelected ?? this.isAllSelected,
    );
  }
}
