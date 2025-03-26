import 'package:equatable/equatable.dart';

class District extends Equatable {
  final int districtId;
  final int provinceId;
  final String districtName;
  final List<String> nameExtension;

  const District({
    required this.districtId,
    required this.provinceId,
    required this.districtName,
    required this.nameExtension,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [districtId, provinceId];
}
