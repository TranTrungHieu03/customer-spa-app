import 'package:equatable/equatable.dart';

class Ward extends Equatable {
  final String wardCode;
  final int districtId;
  final String wardName;
  // final List<String> nameExtension;

  const Ward({
    required this.wardCode,
    required this.districtId,
    required this.wardName,
    // required this.nameExtension,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [wardCode, districtId];
}
