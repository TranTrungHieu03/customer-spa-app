part of 'form_skin_bloc.dart';

@immutable
sealed class FormSkinEvent extends Equatable {
  const FormSkinEvent();
}

final class OnPageChangedEvent extends FormSkinEvent {
  final int pageIndex;

  const OnPageChangedEvent({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}

class NextPageEvent extends FormSkinEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
