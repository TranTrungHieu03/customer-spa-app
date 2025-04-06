import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spa_mobile/features/product/data/model/product_cart_model.dart';

part 'checkbox_cart_state.dart';

class CheckboxCartCubit extends Cubit<CheckboxCartState> {
  CheckboxCartCubit(List<ProductCartModel> productCarts) : super(_initializeState(productCarts));

  static CheckboxCartInitial _initializeState(List<ProductCartModel> productCarts) {
    final Map<int, List<CartStatusState>> groupedProducts = {};

    for (var productCart in productCarts) {
      final branchId = productCart.product.branchId;
      final cartState = CartStatusState(
        id: productCart.product.productBranchId,
        branchId: branchId,
        status: false,
        quantity: productCart.quantity, // Truyền quantity từ productCart
      );

      if (!groupedProducts.containsKey(branchId)) {
        groupedProducts[branchId] = [];
      }
      groupedProducts[branchId]!.add(cartState);
    }

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
          return CartStatusState(id: item.id, branchId: item.branchId, status: value, quantity: item.quantity);
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
        final updatedItems = group.items
            .map((item) => CartStatusState(id: item.id, branchId: item.branchId, status: value, quantity: item.quantity))
            .toList();

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
      final updatedItems =
          group.items.map((item) => CartStatusState(id: item.id, branchId: item.branchId, status: value, quantity: item.quantity)).toList();

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

  void updateProductQuantity(int productId, int newQuantity) {
    final currentState = state as CheckboxCartInitial;

    final updatedGroups = currentState.branchGroups.map((group) {
      final updatedItems = group.items.map((item) {
        if (item.id == productId) {
          return item.copyWith(quantity: newQuantity);
        }
        return item;
      }).toList();

      return group.copyWith(items: updatedItems);
    }).toList();

    emit(currentState.copyWith(branchGroups: updatedGroups));
  }

  void deleteItem(int productId) {
    final currentState = state as CheckboxCartInitial;

    // Create new list of groups with the item removed
    final updatedGroups = currentState.branchGroups.map((group) {
      final updatedItems = group.items.where((item) => item.id != productId).toList();
      return group.copyWith(items: updatedItems);
    }).toList();

    // Remove empty branch groups
    final nonEmptyGroups = updatedGroups.where((group) => group.items.isNotEmpty).toList();

    // Check if all remaining groups are selected
    final isAllSelected = nonEmptyGroups.isNotEmpty && nonEmptyGroups.every((group) => group.isGroupSelected);

    emit(currentState.copyWith(
      branchGroups: nonEmptyGroups,
      isAllSelected: isAllSelected,
    ));
  }

  // Delete multiple items by their IDs
  void deleteMultipleItems(List<int> productIds) {
    final currentState = state as CheckboxCartInitial;

    // Create new list of groups with the items removed
    final updatedGroups = currentState.branchGroups.map((group) {
      final updatedItems = group.items.where((item) => !productIds.contains(item.id)).toList();
      return group.copyWith(items: updatedItems);
    }).toList();

    // Remove empty branch groups
    final nonEmptyGroups = updatedGroups.where((group) => group.items.isNotEmpty).toList();

    // Check if all remaining groups are selected
    final isAllSelected = nonEmptyGroups.isNotEmpty && nonEmptyGroups.every((group) => group.isGroupSelected);

    emit(currentState.copyWith(
      branchGroups: nonEmptyGroups,
      isAllSelected: isAllSelected,
    ));
  }

  // Delete all selected items
  void deleteSelectedItems() {
    final selectedIds = getSelectedItemIds();
    if (selectedIds.isNotEmpty) {
      deleteMultipleItems(selectedIds);
    }
  }
}
