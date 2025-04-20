part of 'skin_analysis_bloc.dart';

@immutable
sealed class SkinAnalysisEvent {}

final class AnalysisViaImageEvent extends SkinAnalysisEvent {
  final SkinAnalysisViaImageParams params;

  AnalysisViaImageEvent(this.params);
}

final class AnalysisViaFormEvent extends SkinAnalysisEvent {
  final SkinAnalysisViaFormParams params;

  AnalysisViaFormEvent(this.params);
}
final class ResetSkinAnalysisEvent extends SkinAnalysisEvent {}
