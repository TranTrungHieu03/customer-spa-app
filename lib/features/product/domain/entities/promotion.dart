import 'package:equatable/equatable.dart';

class Promotion extends Equatable {
  final int promotionId;
  final String promotionName;
  final String promotionDescription;
  final int discountPercent;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String image;

  const Promotion({
    required this.promotionId,
    required this.promotionName,
    required this.promotionDescription,
    required this.discountPercent,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.image,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [promotionId, promotionName];
}
