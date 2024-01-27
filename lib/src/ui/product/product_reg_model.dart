// ignore_for_file: non_constant_identifier_names

import 'package:ku_animal_m/src/model/base_model.dart';

class ProductRegModel extends BaseModel {
  bool data = false;

  ProductRegModel({required this.data});

  ProductRegModel.fromJson(Map<String, dynamic> json) {
    // if (json['data'] != null) {
    //   resultMsg = json['result'] ?? "";
    //   msg = json['msg'] ?? "";
    // }
    result = json['result'] ?? "";
    msg = json['msg'] ?? "";

    // data = json['data'] != null ? UserData.fromJson(json['data']) : UserData();
    if (json['data'] != null) {
      data = json['data'] ?? false;
    }
  }
}
