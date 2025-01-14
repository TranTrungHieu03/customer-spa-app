part of 'form_data_skin_bloc.dart';

@immutable
sealed class FormDataSkinState {}

final class FormDataSkinInitial extends FormDataSkinState {}

final class FormDataSkinUpdated extends FormDataSkinState {
  final SkinHealthModel values;

  FormDataSkinUpdated(this.values);
}
