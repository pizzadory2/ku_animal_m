class InvenModel {
  final String mst_seq;
  final String mst_year;
  final String mst_month;
  final String mst_code;
  final String mst_name;
  final String mst_class;
  final String mst_ingredients;
  final String mst_manufacturer;
  final String mst_content;
  final String mst_dosage;
  final String mst_unit;
  final String mst_standard_code;
  final String mst_lot_code;
  final String mst_barcode;
  final String mst_in_stock;
  final String mst_out_stock;
  final String mst_base_stock;
  final String mi_safety_stock;

  InvenModel({
    required this.mst_seq,
    required this.mst_year,
    required this.mst_month,
    required this.mst_code,
    required this.mst_name,
    required this.mst_class,
    required this.mst_ingredients,
    required this.mst_manufacturer,
    required this.mst_content,
    required this.mst_dosage,
    required this.mst_unit,
    required this.mst_standard_code,
    required this.mst_lot_code,
    required this.mst_barcode,
    required this.mst_in_stock,
    required this.mst_out_stock,
    required this.mst_base_stock,
    required this.mi_safety_stock,
  });

  factory InvenModel.fromJson(Map<String, dynamic> json) {
    return InvenModel(
      mst_seq: json['mst_seq'] ?? "",
      mst_year: json['mst_year'] ?? "",
      mst_month: json['mst_month'] ?? "",
      mst_code: json['mst_code'] ?? "",
      mst_name: json['mst_name'] ?? "",
      mst_class: json['mst_class'] ?? "",
      mst_ingredients: json['mst_ingredients'] ?? "",
      mst_manufacturer: json['mst_manufacturer'] ?? "",
      mst_content: json['mst_content'] ?? "",
      mst_dosage: json['mst_dosage'] ?? "",
      mst_unit: json['mst_unit'] ?? "",
      mst_standard_code: json['mst_standard_code'] ?? "",
      mst_lot_code: json['mst_lot_code'] ?? "",
      mst_barcode: json['mst_barcode'] ?? "",
      mst_in_stock: json['mst_in_stock'] ?? "",
      mst_out_stock: json['mst_out_stock'] ?? "",
      mst_base_stock: json['mst_base_stock'] ?? "",
      mi_safety_stock: json['mi_safety_stock'] ?? "",
    );
  }
}
