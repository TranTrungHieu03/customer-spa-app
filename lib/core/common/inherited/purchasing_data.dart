import 'package:flutter/material.dart';

class PurchasingDataController extends ChangeNotifier {
  int _totalItems = 0;
  double _totalPrice = 0;

  int get totalItems => _totalItems;

  double get totalPrice => _totalPrice;

  void updateTotalItems(int totalItems) {
    _totalItems = totalItems;
    notifyListeners();
  }

  void updateTotalPrice(double totalPrice) {
    _totalPrice = totalPrice;
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
