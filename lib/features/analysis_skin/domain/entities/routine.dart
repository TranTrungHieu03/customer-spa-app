class Routine {
  final int skincareRoutineId;
  final String name;
  final String description;
  final String steps;
  final double totalPrice;
  final String frequency;
  final String targetSkinTypes;

  Routine(
      {required this.skincareRoutineId,
      required this.name,
      required this.description,
      required this.steps,
      required this.frequency,
      required this.targetSkinTypes,
      required this.totalPrice});
}
