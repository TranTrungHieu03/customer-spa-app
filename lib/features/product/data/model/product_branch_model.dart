import 'package:spa_mobile/core/common/model/branch_model.dart';

class ProductBranchModel {
  final int productBranchId;
  final BranchModel branch;

  ProductBranchModel({
    required this.productBranchId,
    required this.branch,
  });

  factory ProductBranchModel.fromJson(Map<String, dynamic> json) {
    return ProductBranchModel(
      productBranchId: json['id'] as int,
      branch: BranchModel.fromJson(json['branch'] as Map<String, dynamic>),
    );
  }
}
