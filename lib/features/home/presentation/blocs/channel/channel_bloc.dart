import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/home/data/models/channel_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_channel.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_channel_by_appointment.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final GetChannel _getChannel;
  final GetChannelByAppointment _getChannelByAppointment;

  ChannelBloc({required GetChannel getChannel, required GetChannelByAppointment getChannelByAppointment})
      : _getChannel = getChannel,
        _getChannelByAppointment = getChannelByAppointment,
        super(ChannelInitial()) {
    on<GetChannelEvent>((event, emit) async {
      emit(ChannelLoading());
      final result = await _getChannel(event.params);
      result.fold((x) => emit(ChannelError(x)), (data) => emit(ChannelLoaded(data)));
    });
    on<GetChannelByAppointmentEvent>((event, emit) async {
      emit(ChannelLoading());
      final result = await _getChannelByAppointment(event.params);
      result.fold((x) => emit(ChannelError(x)), (data) => emit(ChannelLoaded(data)));
    });
  }
}
