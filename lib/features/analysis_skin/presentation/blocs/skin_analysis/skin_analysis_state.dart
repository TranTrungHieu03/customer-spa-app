part of 'skin_analysis_bloc.dart';

@immutable
sealed class SkinAnalysisState {
  const SkinAnalysisState();
}

final class SkinAnalysisInitial extends SkinAnalysisState {}

final class SkinAnalysisLoading extends SkinAnalysisState {}

final class SkinAnalysisLoaded extends SkinAnalysisState {
  final List<RoutineModel> routines;
  final SkinHealthModel skinHealth;

  const SkinAnalysisLoaded({required this.routines, required this.skinHealth});
}

final class SkinAnalysisError extends SkinAnalysisState {
  String message;

  SkinAnalysisError(this.message);
}
