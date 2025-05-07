part of 'list_skinhealth_bloc.dart';

@immutable
sealed class ListSkinhealthEvent {}

final class GetListSkinHealthEvent extends ListSkinhealthEvent {
  final GetListSkinHealthParams params;

  GetListSkinHealthEvent(this.params);
}
