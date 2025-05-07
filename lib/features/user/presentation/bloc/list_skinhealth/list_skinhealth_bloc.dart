import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/core/usecase/usecase.dart';
import 'package:spa_mobile/features/user/data/model/skinhealth_statistic_model.dart';
import 'package:spa_mobile/features/user/domain/usecases/list_skinhealth.dart';

part 'list_skinhealth_event.dart';
part 'list_skinhealth_state.dart';

class ListSkinhealthBloc extends Bloc<ListSkinhealthEvent, ListSkinhealthState> {
  final GetListSkinHealth _getListSkinHealth;

  ListSkinhealthBloc({required GetListSkinHealth getListSkinHealth})
      : _getListSkinHealth = getListSkinHealth,
        super(ListSkinhealthInitial()) {
    on<GetListSkinHealthEvent>((event, emit) async {
      emit(ListSkinhealthLoading());
      final result = await _getListSkinHealth(event.params);
      result.fold((message) => emit(ListSkinhealthError(message.message)), (data) {
        emit(ListSkinhealthLoaded(data));
      });
    });
  }
}
