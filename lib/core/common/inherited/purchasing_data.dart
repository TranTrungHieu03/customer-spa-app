import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/product/data/model/shipment_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';

class PurchasingDataController extends ChangeNotifier {
  int _branchId = 0;
  UserModel? _user;
  late BranchModel _branch;
  ShipmentModel _shipment = ShipmentModel.empty();
  double _totalPrice = 0;
  List<ProductQuantity> _products = [];
  int _serviceGHN = 0;
  int _shippingCost = 0;
  String _expectedDate = "";

  int get branchId => _branchId;

  double get totalPrice => _totalPrice;

  List<ProductQuantity> get products => _products;

  UserModel? get user => _user;

  int get serviceGHN => _serviceGHN;

  ShipmentModel get shipment => _shipment;

  BranchModel? get branch => _branch;

  int get shippingCost => _shippingCost;

  String get expectedDate => _expectedDate;

  void updateBranchId(int branchId) {
    _branchId = branchId;
    notifyListeners();
  }

  void updateShippingCost(int shippingCost) {
    _shippingCost = shippingCost;
    notifyListeners();
  }

  void updateExpectedDate(String date) {
    _expectedDate = date;
    notifyListeners();
  }

  void updateServiceGHN(int id) {
    _serviceGHN = id;
    notifyListeners();
  }

  void updateBranch(BranchModel branch) {
    _branch = branch;
    notifyListeners();
  }

  void updateShipment(ShipmentModel shipment) {
    _shipment = shipment;
    notifyListeners();
  }

  void updateUser(UserModel? user) {
    _user = user;
    _shipment = ShipmentModel(
        address: user?.address ?? "",
        name: user?.fullName ?? "",
        phoneNumber: user?.phoneNumber ?? "",
        districtId: user?.district.toString() ?? "",
        wardCode: user?.wardCode.toString() ?? "");
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
