part of 'list_message_bloc.dart';

@immutable
sealed class ListMessageEvent {}
final class GetListMessageEvent extends ListMessageEvent{

}