class BookRoutineParams {
  final int userId;
  final int routineId;
  final int branchId;
  final String appointmentTime;
  final String note;
  final int voucherId;

  BookRoutineParams(
      {required this.userId,
      required this.routineId,
      required this.branchId,
      required this.appointmentTime,
      required this.voucherId,
      required this.note});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'routineId': routineId,
      'branchId': branchId,
      'appointmentTime': appointmentTime,
      'voucherId': voucherId,
      'note': note
    };
  }
}
