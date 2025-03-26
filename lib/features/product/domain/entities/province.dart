import 'package:equatable/equatable.dart';

class Province extends Equatable {
  final int provinceId;
  final String provinceName;
  final int countryId;
  final List<String> nameExtension;

  const Province({
    required this.provinceId,
    required this.provinceName,
    required this.countryId,
    required this.nameExtension,
  });

  @override
  List<Object?> get props => [provinceId];
}
