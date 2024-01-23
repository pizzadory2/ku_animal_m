class ProductHistoryModel {
  final String num;
  final String msr_seq;
  final String mi_code;
  final String mi_type;
  final String mi_class;
  final String mi_name;
  final String mi_ingredients;
  final String mi_manufacturer;
  final String mi_content;
  final String mi_dosage;
  final String mi_unit;
  final String mi_standard_code;
  final String mi_lot_code;
  final String mi_safety_stock;
  final String mi_barcode;
  final String msr_qty;
  final String msr_man;
  final String tu_name;
  final String mi_type_name;
  final String mi_class_name;

  ProductHistoryModel({
    this.num = "",
    this.msr_seq = "",
    this.mi_code = "",
    this.mi_type = "",
    this.mi_class = "",
    this.mi_name = "",
    this.mi_ingredients = "",
    this.mi_manufacturer = "",
    this.mi_content = "",
    this.mi_dosage = "",
    this.mi_unit = "",
    this.mi_standard_code = "",
    this.mi_lot_code = "",
    this.mi_safety_stock = "",
    this.mi_barcode = "",
    this.msr_qty = "",
    this.msr_man = "",
    this.tu_name = "",
    this.mi_type_name = "",
    this.mi_class_name = "",
  });

  factory ProductHistoryModel.fromJson(Map<String, dynamic> json) {
    return ProductHistoryModel(
      num: json['num'] ?? "",
      msr_seq: json['msr_seq'] ?? "",
      mi_code: json['mi_code'] ?? "",
      mi_type: json['mi_type'] ?? "",
      mi_class: json['mi_class'] ?? "",
      mi_name: json['mi_name'] ?? "",
      mi_ingredients: json['mi_ingredients'] ?? "",
      mi_manufacturer: json['mi_manufacturer'] ?? "",
      mi_content: json['mi_content'] ?? "",
      mi_dosage: json['mi_dosage'] ?? "",
      mi_unit: json['mi_unit'] ?? "",
      mi_standard_code: json['mi_standard_code'] ?? "",
      mi_lot_code: json['mi_lot_code'] ?? "",
      mi_safety_stock: json['mi_safety_stock'] ?? "",
      mi_barcode: json['mi_barcode'] ?? "",
      msr_qty: json['msr_qty'] ?? "",
      msr_man: json['msr_man'] ?? "",
      tu_name: json['tu_name'] ?? "",
      mi_type_name: json['mi_type_name'] ?? "",
      mi_class_name: json['mi_class_name'] ?? "",
    );
  }
}
