import 'package:flutter/material.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';

class PurchasingDataController extends ChangeNotifier {
  int _branchId = 0;
  int _userId = 0;
  double _totalPrice = 0;
  List<ProductQuantity> _products = [];

  int get branchId => _branchId;

  double get totalPrice => _totalPrice;

  List<ProductQuantity> get products => _products;

  void updateBranchId(int branchId) {
    _branchId = branchId;
    notifyListeners();
  }

  void updateUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  void updateTotalPrice(double totalPrice) {
    _totalPrice = totalPrice;
    notifyListeners();
  }

  void updateProducts(List<ProductQuantity> products) {
    _products = products;
    notifyListeners();
  }
}

class PurchasingData extends InheritedNotifier<PurchasingDataController> {
  const PurchasingData({
    super.key,
    required PurchasingDataController controller,
    required super.child,
  }) : super(notifier: controller);

  static PurchasingDataController of(BuildContext context) {
    final PurchasingData? inheritedWidget = context.dependOnInheritedWidgetOfExactType<PurchasingData>();
    assert(inheritedWidget != null, 'No Purchasing data found in context');
    return inheritedWidget!.notifier!;
  }
}
