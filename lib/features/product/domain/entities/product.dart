class Product {
  final int productId;
  final int productBranchId;
  final int stockQuantity;
  final String productName;
  final String productDescription;
  final double price;
  final int quantity;
  final String dimension;
  final String status;
  final String brand;
  final int categoryId;
  final int companyId;
  final int branchId;
  final List<String>? images;

  Product({
    this.images,
    required this.branchId,
    required this.productBranchId,
    required this.stockQuantity,
    required this.dimension,
    required this.productId,
    required this.brand,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.quantity,
    required this.status,
    required this.categoryId,
    required this.companyId,
  });
}
