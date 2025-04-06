import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spa_mobile/features/home/data/models/channel_model.dart';
import 'package:spa_mobile/features/home/domain/usecases/get_list_channel.dart';

part 'list_channel_event.dart';
part 'list_channel_state.dart';

class ListChannelBloc extends Bloc<ListChannelEvent, ListChannelState> {
  final GetListChannel _getListChannel;

  ListChannelBloc({required GetListChannel getListChannel})
      : _getListChannel = getListChannel,
        super(ListChannelInitial()) {
    on<GetListChannelEvent>((event, emit) async {
      emit(ListChannelLoading());
      final result = await _getListChannel(event.params);
      result.fold((failure) => emit(ListChannelError(failure.message)), (data) => emit(ListChannelLoaded(data)));
    });
  }
}
