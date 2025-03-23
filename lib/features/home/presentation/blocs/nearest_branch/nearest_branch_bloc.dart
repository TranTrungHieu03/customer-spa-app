import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'nearest_branch_event.dart';
part 'nearest_branch_state.dart';

class NearestBranchBloc extends Bloc<NearestBranchEvent, NearestBranchState> {
  NearestBranchBloc() : super(NearestBranchInitial()) {
    on<NearestBranchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
