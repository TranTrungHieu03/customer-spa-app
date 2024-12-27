class Product {
  final int productId;
  final String productName;
  final String productDescription;
  final double price;
  final int quantity;
  final String dimension;
  final double discount;
  final String status;
  final int categoryId;
  final int companyId;

  Product({
    required this.dimension,
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.status,
    required this.categoryId,
    required this.companyId,
  });

}