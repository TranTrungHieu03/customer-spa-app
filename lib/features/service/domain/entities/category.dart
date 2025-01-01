import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int categoryId;
  final String name;
  final String description;

  final String status;
  final String imageUrl;

  const Category({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.status,
    required this.imageUrl,
  });

  Category copyWith({
    int? categoryId,
    String? name,
    String? description,
    String? status,
    String? imageUrl,
  }) =>
      Category(
        categoryId: categoryId ?? this.categoryId,
        name: name ?? this.name,
        description: description ?? this.description,
        status: status ?? this.status,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
