import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/core/utils/constants/date_time.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';
import 'package:spa_mobile/features/service/data/model/appointment_model.dart';
import 'package:spa_mobile/features/service/data/model/service_model.dart';
import 'package:spa_mobile/features/service/data/model/staff_model.dart';
import 'package:spa_mobile/features/service/data/model/time_model.dart';

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
  List<TimeModel> _selectedSlots = [];
  List<int> _staffIds = [];
  VoucherModel? _voucher;
  String _note = '';
  int _appointmentId = 0;
  DateTime minDate = DateTime.now();
  int _step = 0;
  AppointmentModel _model = AppointmentModel.empty();
  int _orderId = 0;
  int routineId = 0;
  int userId = 0;
  String _method = 'PayOs';

  String get method => _method;

  int get orderId => _orderId;

  int get appointmentId => _appointmentId;

  String get note => _note;

  List<StaffModel?> _staffs = [];

  List<TimeModel> get selectedSlots => _selectedSlots;

  UserModel? get user => _user;

  VoucherModel? get voucher => _voucher;

  List<ServiceModel> get services => _services;

  List<int> get serviceIds => _serviceIds;

  double get totalPrice => _totalPrice;

  int get totalDuration => _totalDuration;

  int get step => _step;

  int get branchId => _branchId;

  BranchModel? get branch => branchModel;

  List<int> get staffIds => _staffIds;

  List<StaffModel?> get staff => _staffs;

  List<DateTime> get time => timeStart;

  AppointmentModel get appt => _model;

  void updateServices(List<ServiceModel> newServices) {
    _services = newServices;
    notifyListeners();
  }

  void updateMethod(String method) {
    _method = method;
    notifyListeners();
  }

  void updateAppointmentModel(AppointmentModel appt) {
    _model = appt;
    notifyListeners();
  }

  void updateStep(int value) {
    _step = value;
    notifyListeners();
  }

  void updateOrderId(int value) {
    _orderId = value;
    notifyListeners();
  }

  void updateRoutineId(int value) {
    routineId = value;
    notifyListeners();
  }

  void updateUserId(int value) {
    userId = value;
    notifyListeners();
  }

  void addSlot(TimeModel value) {
    AppLogger.info(value);
    _selectedSlots.add(value);
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

  void updateVoucher(VoucherModel newServices) {
    _voucher = newServices;
    notifyListeners();
  }

  void updateMinDate(DateTime date) {
    minDate = date;
    notifyListeners();
  }

  void updateUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void updateServiceIds(List<int> newServiceIds) {
    _serviceIds = newServiceIds;
    _staffIds = List.filled(newServiceIds.length, -1);
    _staffs = List.filled(newServiceIds.length, null);
    timeStart = List.filled(newServiceIds.length, kDefaultDateTime);
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

  void updateId(int id) {
    _appointmentId = id;
    notifyListeners();
  }

  void updateNote(String note) {
    _note = note;
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

  void updateTimeStartWithIndex(DateTime time, int index) {
    timeStart[index] = time;
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
