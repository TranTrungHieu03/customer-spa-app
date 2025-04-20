part of 'service_categories_bloc.dart';

@immutable
sealed class ServiceCategoriesEvent {}

final class GetServiceCategoriesEvent extends ServiceCategoriesEvent {
  GetServiceCategoriesEvent();
}
