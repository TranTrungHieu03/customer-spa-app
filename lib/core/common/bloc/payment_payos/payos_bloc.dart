import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'payos_event.dart';
part 'payos_state.dart';

class PayosBloc extends Bloc<PayosEvent, PayosState> {
  PayosBloc() : super(PayosInitial()) {
    on<PayosInitiated>((event, emit) {
      emit(PayosLoading());
      emit(PayosWebViewLoaded());
    });

    on<PayosSuccessful>((event, emit) {
      emit(PayosSuccess());
    });

    on<PayosFailed>((event, emit) {
      emit(PayosFailure());
    });

    on<PayosCancelled>((event, emit) {
      emit(PayosFailure());
    });

    on<RetryPayos>((event, emit) {
      emit(PayosLoading());
      emit(PayosWebViewLoaded());
    });
    on<RefreshPayOS>((event, emit) {
      emit(PayosInitial());
    });
    //
    // on<NavigateToHome>((event, emit) {
    //   emit(PayosInitial());
    // });
  }
}
