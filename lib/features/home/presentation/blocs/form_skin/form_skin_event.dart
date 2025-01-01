part of 'form_skin_bloc.dart';

@immutable
sealed class FormSkinEvent extends Equatable {
  const FormSkinEvent();

  @override
  List<Object> get props => [];
}

final class OnPageChangedEvent extends FormSkinEvent {
  final int pageIndex;

  const OnPageChangedEvent({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}

class NextPageEvent extends FormSkinEvent {}
class PreviousPageEvent extends FormSkinEvent {}

