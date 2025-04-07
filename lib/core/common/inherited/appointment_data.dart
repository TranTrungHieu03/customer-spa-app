import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';

// Lớp quản lý state
class AppointmentDataController extends ChangeNotifier {
  List<ServiceModel> _services = [];
  List<int> _serviceIds = [];
  double _totalPrice = 0;
  int _totalDuration = 0;
  int _branchId = 0;
  UserModel? _user = UserModel.empty();
  BranchModel? branchModel;
  List<DateTime> timeStart = [];
  List<int> _staffIds = [];
  VoucherModel? _voucher;

  List<StaffModel?> _staffs = [];

  UserModel? get user => _user;

  VoucherModel? get voucher => _voucher;

  List<ServiceModel> get services => _services;

  List<int> get serviceIds => _serviceIds;

  double get totalPrice => _totalPrice;

  int get totalDuration => _totalDuration;

  int get branchId => _branchId;

  BranchModel? get branch => branchModel;

  List<int> get staffIds => _staffIds;

  List<StaffModel?> get staff => _staffs;

  List<DateTime> get time => timeStart;

  void updateServices(List<ServiceModel> newServices) {
    _services = newServices;
    notifyListeners();
  }

  void updateVoucher(VoucherModel newServices) {
    _voucher = newServices;
    notifyListeners();
  }

  void updateUser(UserModel newServices) {
    _user = newServices;
    notifyListeners();
  }

  void updateServiceIds(List<int> newServiceIds) {
    _serviceIds = newServiceIds;
    _staffIds = List.filled(newServiceIds.length, 0);
    _staffs = List.filled(newServiceIds.length, null);
    timeStart = List.filled(newServiceIds.length, DateTime.now());
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

  void updateStaffIds(int staffId) {
    _staffIds = List.filled(serviceIds.length, staffId);
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
    _staffs = List.filled(serviceIds.length, staff);
    notifyListeners();
  }

  void updateTimeStart(List<DateTime> time) {
    timeStart = time;
    notifyListeners();
  }
}

class AppointmentData extends InheritedNotifier<AppointmentDataController> {
  const AppointmentData({
    super.key,
    required AppointmentDataController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppointmentDataController of(BuildContext context) {
    final AppointmentData? inheritedWidget = context.dependOnInheritedWidgetOfExactType<AppointmentData>();
    assert(inheritedWidget != null, 'No AppointmentData found in context');
    return inheritedWidget!.notifier!;
  }
}
