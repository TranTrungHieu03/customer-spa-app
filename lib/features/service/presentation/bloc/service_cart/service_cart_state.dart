part of 'service_cart_bloc.dart';

@immutable
sealed class ServiceCartState {}

final class ServiceCartInitial extends ServiceCartState {}

class ServiceCartLoading extends ServiceCartState {}

class ServiceCartLoaded extends ServiceCartState {
  final List<ServiceModel> services;
  final bool isVisible;

  ServiceCartLoaded({required this.services, this.isVisible = true});

  double get totalPrice => services.fold(0, (sum, service) => sum + service.price);

  ServiceCartLoaded copyWith({
    List<ServiceModel>? services,
    bool? isVisible,
  }) {
    return ServiceCartLoaded(
      services: services ?? this.services,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class ServiceCartRemove extends ServiceCartState {}

class ServiceCartError extends ServiceCartState {
  final String message;

  ServiceCartError(this.message);
}
