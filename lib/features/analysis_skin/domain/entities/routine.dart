class Routine {
  final int skincareRoutineId;
  final String name;
  final String description;
  final int totalSteps;
  final double totalPrice;
  final String targetSkinTypes;

  Routine(
      {required this.skincareRoutineId,
      required this.name,
      required this.description,
      required this.totalSteps,
      required this.targetSkinTypes,
      required this.totalPrice});
}
