import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/date_time.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/product/data/model/product_model.dart';
import 'package:spa_mobile/features/product/domain/usecases/create_order.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/data/model/time_model.dart';

// Lớp quản lý state
class MixDataController extends ChangeNotifier {
  List<ServiceModel> _services = [];
  List<ProductModel> _products = [];
  List<ProductQuantity> _productQuantities = [];
  double _totalPrice = 0;
  int _totalDuration = 0;
  int _branchId = 0;
  UserModel? _user = UserModel.empty();
  BranchModel? branchModel;
  List<DateTime> timeStart = [];
  List<int> _staffIds = [];
  VoucherModel? _voucher;
  String _method = 'PayOs';
  bool isAuto = true;
  List<TimeModel> _selectedSlots = [];

  String get method => _method;
  List<StaffModel?> _staffs = [];

  UserModel? get user => _user;

  VoucherModel? get voucher => _voucher;

  List<ServiceModel> get services => _services;

  double get totalPrice => _totalPrice;

  int get totalDuration => _totalDuration;

  List<TimeModel> get selectedSlots => _selectedSlots;

  int get branchId => _branchId;

  BranchModel? get branch => branchModel;

  List<int> get staffIds => _staffIds;

  List<StaffModel?> get staff => _staffs;

  List<DateTime> get time => timeStart;

  List<ProductQuantity> get productQuantities => _productQuantities;

  void updateServices(List<ServiceModel> newServices) {
    _services = newServices;
    timeStart = List.generate(_services.length, (index) => kDefaultDateTime);
    _staffIds = List.filled(_services.length, -1);
    _staffs = List.filled(_services.length, null);
    notifyListeners();
  }

  void updateVoucher(VoucherModel newServices) {
    _voucher = newServices;
    notifyListeners();
  }

  void updateMethod(String method) {
    _method = method;
    notifyListeners();
  }

  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void addSlot(TimeModel value) {
    AppLogger.info(value);
    _selectedSlots.add(value);
    notifyListeners();
  }

  void updateTimeStartWithIndex(DateTime time, int index) {
    timeStart[index] = time;
    notifyListeners();
  }

  void removeSlot(DateTime value) {
    _selectedSlots.removeWhere((x) =>
        x.startTime.year == value.year &&
        x.startTime.month == value.month &&
        x.startTime.day == value.day &&
        x.startTime.hour == value.hour &&
        x.startTime.minute == value.minute);
    notifyListeners();
  }

  void clearSlot() {
    _selectedSlots.clear();
    notifyListeners();
  }

  void updateStaffIds(int staffId) {
    _staffIds = List.filled(services.length, staffId);
    notifyListeners();
  }

  void addStaffId(int index, int staffId) {
    _staffIds[index] = staffId;
    notifyListeners();
  }

  void addStaff(int index, StaffModel staff) {
    AppLogger.info("?>>>> index: $index ${_staffs.length}");
    _staffs[index] = staff;
    notifyListeners();
  }

  void updateStaff(StaffModel staff) {
    _staffs = List.filled(services.length, staff);
    notifyListeners();
  }

  void updateTotalPrice(double price) {
    _totalPrice = price;
    notifyListeners();
  }

  void updateTime(int time) {
    _totalDuration = time;
    notifyListeners();
  }

  void updateBranchId(int branchId) {
    _branchId = branchId;
    notifyListeners();
  }

  void updateBranch(BranchModel? branch) {
    branchModel = branch;
    notifyListeners();
  }

  void updateStaffIdForAll(StaffModel staff) {
    _staffIds = List.generate(_staffs.length, (index) => staff.staffId);
    _staffs = List.generate(_staffs.length, (index) => staff);
    notifyListeners();
  }

  void updateTimeStart(List<DateTime> time) {
    timeStart = time;
    notifyListeners();
  }

  void updateTimeWithIndex(int index, DateTime time) {
    timeStart[index] = time;
    notifyListeners();
  }

  void updateProducts(List<ProductModel> products) {
    _products = products;
    _productQuantities = products
        .map((product) => ProductQuantity(
              productBranchId: product.productBranchId,
              quantity: 1,
              product: product,
            ))
        .toList();
    _staffIds = List.generate(_staffs.length, (index) => -1);
    notifyListeners();
  }

  void updateProductQuantity(List<ProductQuantity> productQuantities) {
    _productQuantities = productQuantities;
    notifyListeners();
  }

  void updateProductQuantityItem(int index, int quantity) {
    _productQuantities[index].quantity = quantity;
    notifyListeners();
  }

  void updateAuto(bool auto) {
    isAuto = auto;
    notifyListeners();
  }
}

class MixData extends InheritedNotifier<MixDataController> {
  const MixData({
    super.key,
    required MixDataController controller,
    required super.child,
  }) : super(notifier: controller);

  static MixDataController of(BuildContext context) {
    final MixData? inheritedWidget = context.dependOnInheritedWidgetOfExactType<MixData>();
    assert(inheritedWidget != null, 'No MixData found in context');
    return inheritedWidget!.notifier!;
  }
}
