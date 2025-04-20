import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_form.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_image.dart';

part 'skin_analysis_event.dart';
part 'skin_analysis_state.dart';

class SkinAnalysisBloc extends Bloc<SkinAnalysisEvent, SkinAnalysisState> {
  final SkinAnalysisViaImage _skinAnalysisViaImage;
  final SkinAnalysisViaForm _skinAnalysisViaForm;

  SkinAnalysisBloc({required SkinAnalysisViaImage skinAnalysisViaImage, required SkinAnalysisViaForm skinAnalysisViaForm})
      : _skinAnalysisViaImage = skinAnalysisViaImage,
        _skinAnalysisViaForm = skinAnalysisViaForm,
        super(SkinAnalysisInitial()) {
    on<AnalysisViaImageEvent>(_onAnalysisViaImage);
    on<AnalysisViaFormEvent>(_onAnalysisViaForm);
    on<ResetSkinAnalysisEvent>(_onResetSkinAnalysis);
  }

  Future<void> _onAnalysisViaImage(AnalysisViaImageEvent event, Emitter<SkinAnalysisState> emit) async {
    emit(SkinAnalysisLoading());
    final result = await _skinAnalysisViaImage(event.params);
    AppLogger.debug(">>>>>>> result: $result");
    result.fold(
      (failure) => emit(SkinAnalysisError(failure.message)),
      (data) => emit(SkinAnalysisLoaded(routines: data.routines, skinHealth: data.skinhealth)),
    );
  }

  Future<void> _onAnalysisViaForm(AnalysisViaFormEvent event, Emitter<SkinAnalysisState> emit) async {
    emit(SkinAnalysisLoading());
    final result = await _skinAnalysisViaForm(event.params);

    result.fold(
      (failure) {
        AppLogger.debug(">>>>>>> result: $result");
        emit(SkinAnalysisError(failure.message));
      },
      (data) {
        AppLogger.debug(">>>>>>> result: ${data.skinhealth}");
        emit(SkinAnalysisLoading());
        emit(SkinAnalysisLoaded(routines: data.routines, skinHealth: data.skinhealth));
      },
    );
  }

  Future<void> _onResetSkinAnalysis(ResetSkinAnalysisEvent event, Emitter<SkinAnalysisState> emit) async {
    emit(SkinAnalysisInitial());
  }
}
