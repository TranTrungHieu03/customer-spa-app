import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/routine_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/skin_analysis_via_image.dart';

part 'skin_analysis_event.dart';
part 'skin_analysis_state.dart';

class SkinAnalysisBloc extends Bloc<SkinAnalysisEvent, SkinAnalysisState> {
  final SkinAnalysisViaImage _skinAnalysisViaImage;

  SkinAnalysisBloc({required SkinAnalysisViaImage skinAnalysisViaImage})
      : _skinAnalysisViaImage = skinAnalysisViaImage,
        super(SkinAnalysisInitial()) {
    on<AnalysisViaImageEvent>(_onAnalysisViaImage);
  }

  Future<void> _onAnalysisViaImage(AnalysisViaImageEvent event, Emitter<SkinAnalysisState> emit) async {
    emit(SkinAnalysisLoading());
    final result = await _skinAnalysisViaImage(event.params);
    result.fold(
      (failure) => emit(SkinAnalysisError(failure.message)),
      (data) => emit(SkinAnalysisLoaded(routines: data.routines, skinHealth: data.skinhealth)),
    );
  }
}
