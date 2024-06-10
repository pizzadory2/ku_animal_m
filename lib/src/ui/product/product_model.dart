class ProductModel {
  final String mi_seq;
  final String mi_code;
  final String mi_type;
  final String mi_name;
  final String mi_class;
  final String mi_ingredients;
  final String mi_manufacturer;
  final String mi_content;
  final String mi_dosage;
  final String mi_unit;
  final String mi_standard_code;
  final String mi_lot_code;
  final String mi_barcode;
  final String mi_safety_stock;
  final String mi_etc;
  final String pc_seq;
  final String is_del;
  final String del_date;
  final String reg_date;
  final String mi_type_name;
  final String mi_class_name;
  final String pc_main_name;
  final String mst_in_stock;
  final String mst_out_stock;
  final String mst_base_stock;
  int inout_count = 0;

  ProductModel({
    required this.mi_seq,
    required this.mi_code,
    required this.mi_type,
    required this.mi_name,
    required this.mi_class,
    required this.mi_ingredients,
    required this.mi_manufacturer,
    required this.mi_content,
    required this.mi_dosage,
    required this.mi_unit,
    required this.mi_standard_code,
    required this.mi_lot_code,
    required this.mi_barcode,
    required this.mi_safety_stock,
    required this.mi_etc,
    required this.pc_seq,
    required this.is_del,
    required this.del_date,
    required this.reg_date,
    required this.mi_type_name,
    required this.mi_class_name,
    required this.pc_main_name,
    required this.mst_in_stock,
    required this.mst_out_stock,
    required this.mst_base_stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      mi_seq: json['mi_seq'] ?? "",
      mi_code: json['mi_code'] ?? "",
      mi_type: json['mi_type'] ?? "",
      mi_name: json['mi_name'] ?? "",
      mi_class: json['mi_class'] ?? "",
      mi_ingredients: json['mi_ingredients'] ?? "",
      mi_manufacturer: json['mi_manufacturer'] ?? "",
      mi_content: json['mi_content'] ?? "",
      mi_dosage: json['mi_dosage'] ?? "",
      mi_unit: json['mi_unit'] ?? "",
      mi_standard_code: json['mi_standard_code'] ?? "",
      mi_lot_code: json['mi_lot_code'] ?? "",
      mi_barcode: json['mi_barcode'] ?? "",
      mi_safety_stock: json['mi_safety_stock'] ?? "",
      mi_etc: json['mi_etc'] ?? "",
      pc_seq: json['pc_seq'] ?? "",
      is_del: json['is_del'] ?? "",
      del_date: json['del_date'] ?? "",
      reg_date: json['reg_date'] ?? "",
      mi_type_name: json['mi_type_name'] ?? "",
      mi_class_name: json['mi_class_name'] ?? "",
      pc_main_name: json['pc_main_name'] ?? "",
      mst_in_stock: json['mst_in_stock'] ?? "",
      mst_out_stock: json['mst_out_stock'] ?? "",
      mst_base_stock: json['mst_base_stock'] ?? "",
    );
  }
}
