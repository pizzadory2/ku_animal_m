class ProductModel {
  final String id;
  final String name;
  final String company;
  final String safeCount;
  final String quantity;
  final String element;
  final String regDate;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.company,
    required this.safeCount,
    required this.quantity,
    required this.element,
    required this.regDate,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      company: json['company'],
      safeCount: json['safeCount'],
      quantity: json['quantity'],
      element: json['element'],
      regDate: json['regDate'],
      description: json['description'],
    );
  }
}
