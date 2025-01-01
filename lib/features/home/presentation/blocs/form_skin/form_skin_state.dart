part of 'form_skin_bloc.dart';

@immutable
  class FormSkinState extends Equatable {
  const FormSkinState();

  @override
  List<Object?> get props => [];
}

final class FormSkinInitial extends FormSkinState {}

final class FormSkinLoading extends FormSkinState {}

final class FormSkinLoaded extends FormSkinState {}

final class FormSkinError extends FormSkinState {
  final String message;

  const FormSkinError({required this.message});
}

final class FormSkinPageChanged extends FormSkinState {
  final int pageIndex;

  const FormSkinPageChanged(this.pageIndex);
  @override
  List<Object> get props => [pageIndex];
}

final class FormSkinComplete extends FormSkinState {}
