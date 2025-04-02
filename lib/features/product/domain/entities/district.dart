import 'package:equatable/equatable.dart';

class District extends Equatable {
  final int districtId;
  final int provinceId;
  final String districtName;

  const District({
    required this.districtId,
    required this.provinceId,
    required this.districtName,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [districtId, provinceId];
}
