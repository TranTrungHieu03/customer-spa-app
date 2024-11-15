import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'policy_term_state.dart';

class PolicyTermCubit extends Cubit<PolicyTermState> {
  PolicyTermCubit() : super(PolicyTermInitial());

  void togglePolicyTerm() {
    final currentState = state;
    bool isAccept = true;

    if (currentState is PolicyTermInitial) {
      isAccept = currentState.isAccept;
    } else if (currentState is PolicyTermToggled) {
      isAccept = currentState.isAccept;
    }
    emit(PolicyTermToggled(!isAccept));
  }
}
