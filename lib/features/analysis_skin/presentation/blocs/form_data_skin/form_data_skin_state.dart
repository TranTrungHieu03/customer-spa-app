part of 'form_data_skin_bloc.dart';

@immutable
sealed class FormDataSkinState {}

final class FormDataSkinInitial extends FormDataSkinState {}

final class FormDataSkinUpdated extends FormDataSkinState {
  final SkinHealthModel values;

  FormDataSkinUpdated(this.values);
}

final class FormDataSkinLoading extends FormDataSkinState {}

final class FormDataSkinSuccess extends FormDataSkinState {
  final AnalysisResponseModel response;

  FormDataSkinSuccess(this.response);
}
final class FormDataSkinError extends FormDataSkinState {
  final String message;

  FormDataSkinError(this.message);
}
