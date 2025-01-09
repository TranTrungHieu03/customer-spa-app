import 'package:spa_mobile/features/analysis_skin/data/model/black_head_model.dart';
import 'package:spa_mobile/features/analysis_skin/domain/entities/black_head.dart';

class SkinType {
  final int skinType;
  final List<BlackheadModel> details;

  SkinType({
    required this.skinType,
    required this.details,
  });
}
