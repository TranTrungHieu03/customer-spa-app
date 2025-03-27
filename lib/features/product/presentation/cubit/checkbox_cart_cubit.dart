import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'checkbox_cart_state.dart';

class CheckboxCartCubit extends Cubit<CheckboxCartState> {
  CheckboxCartCubit(List<int> productIds)
      : super(CheckboxCartInitial(
    itemStates: productIds.map((id) => CartState(id: id, status: false)).toList(),
    isAllSelected: false,
  ));

  // ✅ Hàm bật/tắt checkbox của từng sản phẩm
  void toggleItemCheckbox(int id, bool value) {
    final currentState = state as CheckboxCartInitial;

    final updatedItems = currentState.itemStates.map((item) {
      if (item.id == id) {
        return CartState(id: item.id, status: value); // Cập nhật giá trị mới
      }
      return item;
    }).toList();

    final isAllSelected = updatedItems.every((item) => item.status);

    emit(currentState.copyWith(itemStates: updatedItems, isAllSelected: isAllSelected));
  }

  // ✅ Hàm chọn tất cả sản phẩm
  void toggleSelectAll(bool value) {
    final currentState = state as CheckboxCartInitial;

    final updatedItems = currentState.itemStates
        .map((item) => CartState(id: item.id, status: value))
        .toList();

    emit(currentState.copyWith(itemStates: updatedItems, isAllSelected: value));
  }
}
