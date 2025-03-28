part of 'form_data_skin_bloc.dart';

@immutable
sealed class FormDataSkinEvent {}

class UpdateSkinHealthEvent extends FormDataSkinEvent {
  final SkinHealthModel values;

  UpdateSkinHealthEvent(this.values);
}

class SubmitSkinHealthEvent extends FormDataSkinEvent {
  final SkinHealthModel values;

  SubmitSkinHealthEvent(this.values);
}
