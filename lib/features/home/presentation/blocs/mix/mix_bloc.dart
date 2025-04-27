import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/analysis_skin/domain/usecases/order_mix.dart';

part 'mix_event.dart';
part 'mix_state.dart';

class MixBloc extends Bloc<MixEvent, MixState> {
  final OrderMix _orderMix;

  MixBloc({required OrderMix orderMix})
      : _orderMix = orderMix,
        super(MixInitial()) {
    on<OrderMixEvent>((event, emit) async {
      emit(OrderMixLoading());
      final result = await _orderMix(event.params);
      result.fold(
        (failure) => emit(OrderMixError(failure.message)),
        (data) {
          emit(OrderMixSuccess(data));
        },
      );
    });
  }
}
