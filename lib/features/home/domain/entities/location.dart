import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String address;
  final String formatAddress;

  Location({required this.address, required this.formatAddress});

  @override
  List<Object?> get props => [formatAddress];
}
