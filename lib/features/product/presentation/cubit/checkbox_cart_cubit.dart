import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';

part 'checkbox_cart_state.dart';

//
// class CheckboxCartCubit extends Cubit<CheckboxCartState> {
//   CheckboxCartCubit(List<int> productIds)
//       : super(CheckboxCartInitial(
//           itemStates: productIds.map((id) => CartStatusState(id: id, status: false)).toList(),
//           isAllSelected: false,
//         ));
//
//   void toggleItemCheckbox(int id, bool value) {
//     final currentState = state as CheckboxCartInitial;
//
//     final updatedItems = currentState.itemStates.map((item) {
//       if (item.id == id) {
//         return CartStatusState(id: item.id, status: value);
//       }
//       return item;
//     }).toList();
//
//     final isAllSelected = updatedItems.every((item) => item.status);
//
//     emit(currentState.copyWith(itemStates: updatedItems, isAllSelected: isAllSelected));
//   }
//
//   // ✅ Hàm chọn tất cả sản phẩm
//   void toggleSelectAll(bool value) {
//     final currentState = state as CheckboxCartInitial;
//
//     final updatedItems = currentState.itemStates.map((item) => CartStatusState(id: item.id, status: value)).toList();
//
//     emit(currentState.copyWith(itemStates: updatedItems, isAllSelected: value));
//   }
// }

class CheckboxCartCubit extends Cubit<CheckboxCartState> {
  CheckboxCartCubit(List<ProductCartModel> productCarts) : super(_initializeState(productCarts));

  static CheckboxCartInitial _initializeState(List<ProductCartModel> productCarts) {
    // Group products by branchId
    final Map<int, List<CartStatusState>> groupedProducts = {};

    // Populate groups
    for (var productCart in productCarts) {
      final branchId = productCart.product.branchId;
      final cartState = CartStatusState(id: productCart.product.productBranchId, branchId: branchId, status: false);

      if (!groupedProducts.containsKey(branchId)) {
        groupedProducts[branchId] = [];
      }

      groupedProducts[branchId]!.add(cartState);
    }

    // Convert map to list of branch groups
    final branchGroups = groupedProducts.entries.map((entry) {
      return CartBranchGroup(
        branchId: entry.key,
        items: entry.value,
        isGroupSelected: false,
      );
    }).toList();

    return CheckboxCartInitial(
      branchGroups: branchGroups,
      isAllSelected: false,
    );
  }

  // Toggle individual item
  void toggleItemCheckbox(int id, bool value) {
    final currentState = state as CheckboxCartInitial;
    final updatedGroups = currentState.branchGroups.map((group) {
      final updatedItems = group.items.map((item) {
        if (item.id == id) {
          return CartStatusState(id: item.id, branchId: item.branchId, status: value);
        }
        return item;
      }).toList();

      // Update group selection status
      final isGroupSelected = updatedItems.every((item) => item.status);

      return CartBranchGroup(
        branchId: group.branchId,
        items: updatedItems,
        isGroupSelected: isGroupSelected,
      );
    }).toList();

    // Check if all groups are selected
    final isAllSelected = updatedGroups.every((group) => group.isGroupSelected);

    emit(currentState.copyWith(branchGroups: updatedGroups, isAllSelected: isAllSelected));
  }

  // Toggle an entire branch group
  void toggleBranchGroup(int branchId, bool value) {
    final currentState = state as CheckboxCartInitial;
    final updatedGroups = currentState.branchGroups.map((group) {
      if (group.branchId == branchId) {
        final updatedItems = group.items.map((item) => CartStatusState(id: item.id, branchId: item.branchId, status: value)).toList();

        return CartBranchGroup(
          branchId: group.branchId,
          items: updatedItems,
          isGroupSelected: value,
        );
      }
      return group;
    }).toList();

    // Check if all groups are selected
    final isAllSelected = updatedGroups.every((group) => group.isGroupSelected);

    emit(currentState.copyWith(branchGroups: updatedGroups, isAllSelected: isAllSelected));
  }

  // Toggle all items across all branches
  void toggleSelectAll(bool value) {
    final currentState = state as CheckboxCartInitial;

    final updatedGroups = currentState.branchGroups.map((group) {
      final updatedItems = group.items.map((item) => CartStatusState(id: item.id, branchId: item.branchId, status: value)).toList();

      return CartBranchGroup(
        branchId: group.branchId,
        items: updatedItems,
        isGroupSelected: value,
      );
    }).toList();

    emit(currentState.copyWith(branchGroups: updatedGroups, isAllSelected: value));
  }

  // Get selected item IDs
  List<int> getSelectedItemIds() {
    final currentState = state as CheckboxCartInitial;
    final selectedIds = <int>[];

    for (var group in currentState.branchGroups) {
      for (var item in group.items) {
        if (item.status) {
          selectedIds.add(item.id);
        }
      }
    }

    return selectedIds;
  }
}
