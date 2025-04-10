import 'package:equatable/equatable.dart';

class Feedback extends Equatable {
  final int customerId;
  final int? userId;
  final String? comment;
  final int? rating;
  final String status;
  final String? imageBefore;
  final String? imageAfter;
  final String? createdBy;
  final String? updatedBy;
  final String createdAt;
  final String updatedAt;

  Feedback(
      {required this.customerId,
      this.userId,
      this.comment,
      this.rating,
      required this.status,
      this.imageBefore,
      this.imageAfter,
      this.createdBy,
      this.updatedBy,
      required this.createdAt,
      required this.updatedAt});

  @override
  // TODO: implement props
  List<Object?> get props => [customerId, comment, status, createdAt];
}
