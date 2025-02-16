import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/analysis_response_model.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';

part 'form_data_skin_event.dart';
part 'form_data_skin_state.dart';

class FormDataSkinBloc extends Bloc<FormDataSkinEvent, FormDataSkinState> {
  FormDataSkinBloc() : super(FormDataSkinInitial()) {
    on<UpdateSkinHealthEvent>(_onUpdateSkinHealthEvent);
        on<SubmitSkinHealthEvent>(_onSubmitSkinHealthEvent);
  }

  Future<void> _onUpdateSkinHealthEvent(UpdateSkinHealthEvent event, Emitter<FormDataSkinState> emit) async {

    emit(FormDataSkinUpdated(event.values));
  }
  Future<void> _onSubmitSkinHealthEvent(SubmitSkinHealthEvent event, Emitter<FormDataSkinState> emit) async {
    emit(FormDataSkinLoading());
    try {
      // final response = await _skinAnalysisViaForm(SkinAnalysisViaFormParams(event.values));

    } catch (e) {

      emit(FormDataSkinError(e.toString()));
    }
  }
}
