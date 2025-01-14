import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';
import 'package:spa_mobile/features/analysis_skin/data/model/skin_health_model.dart';

part 'form_data_skin_event.dart';
part 'form_data_skin_state.dart';

class FormDataSkinBloc extends Bloc<FormDataSkinEvent, FormDataSkinState> {
  FormDataSkinBloc() : super(FormDataSkinInitial()) {
    on<UpdateSkinHealthEvent>(_onUpdateSkinHealthEvent);
  }

  Future<void> _onUpdateSkinHealthEvent(UpdateSkinHealthEvent event, Emitter<FormDataSkinState> emit) async {
    AppLogger.info(event.values.toJson());
    emit(FormDataSkinUpdated(event.values));
  }
}
