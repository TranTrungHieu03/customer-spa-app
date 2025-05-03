import 'package:flutter/material.dart';
import 'package:spa_mobile/core/common/model/branch_model.dart';
import 'package:spa_mobile/core/common/model/voucher_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/auth/data/models/user_model.dart';

class RoutineDataController extends ChangeNotifier {
  UserModel? _user = UserModel.empty();
  late BranchModel _branch;
  late RoutineModel _routine;
  VoucherModel? _voucher;
  double _totalPrice = 0;
  String _time = '';

  String _method = 'PayOS';

  String get time => _time;

  VoucherModel? get voucher => _voucher;

  double get totalPrice => _totalPrice;

  UserModel? get user => _user;

  RoutineModel get routine => _routine;

  BranchModel? get branch => _branch;

  String get method => _method;

  void updateMethod(String method) {
    _method = method;
    notifyListeners();
  }

  void updateRoutine(RoutineModel routine) {
    _routine = routine;
    _totalPrice = routine.totalPrice;
    notifyListeners();
  }

  void updateVoucher(VoucherModel voucher) {
    _voucher = voucher;
    notifyListeners();
  }

  void updateBranch(BranchModel branch) {
    _branch = branch;
    notifyListeners();
  }

  void updateUser(UserModel? user) {
    _user = user;

    notifyListeners();
  }

  void updateTotalPrice(double totalPrice) {
    _totalPrice = totalPrice;
    notifyListeners();
  }

  void updateTime(String time) {
    _time = time;
    notifyListeners();
  }
}

class RoutineData extends InheritedNotifier<RoutineDataController> {
  const RoutineData({
    super.key,
    required RoutineDataController controller,
    required super.child,
  }) : super(notifier: controller);

  static RoutineDataController of(BuildContext context) {
    final RoutineData? inheritedWidget = context.dependOnInheritedWidgetOfExactType<RoutineData>();
    assert(inheritedWidget != null, 'No Routine data found in context');
    return inheritedWidget!.notifier!;
  }
}
