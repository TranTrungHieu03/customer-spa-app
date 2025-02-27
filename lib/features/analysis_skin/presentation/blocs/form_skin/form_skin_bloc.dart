import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/logger/logger.dart';

part 'form_skin_event.dart';
part 'form_skin_state.dart';

class FormSkinBloc extends Bloc<FormSkinEvent, FormSkinState> {
  int currentIndex = 0;

  FormSkinBloc() : super(FormSkinInitial()) {
    on<NextPageEvent>(_onNextPage);
    on<PreviousPageEvent>(_onPreviousPage);
    on<OnPageChangedEvent>(_onPageChanged);
  }

  Future<void> _onNextPage(NextPageEvent event, Emitter<FormSkinState> emit) async {
    if (currentIndex < 10) {
      currentIndex++;
      AppLogger.debug(currentIndex);
      emit(FormSkinPageChanged(currentIndex));
    } else {
      emit(FormSkinComplete());
    }
  }

  Future<void> _onPreviousPage(PreviousPageEvent event, Emitter<FormSkinState> emit) async {
    if (currentIndex > 0) {
      currentIndex--;
      emit(FormSkinPageChanged(currentIndex));
    } else {
      emit(FormSkinComplete());
    }
  }

  Future<void> _onPageChanged(OnPageChangedEvent event, Emitter<FormSkinState> emit) async {
    currentIndex = event.pageIndex;
    emit(FormSkinPageChanged(currentIndex));
  }
}
