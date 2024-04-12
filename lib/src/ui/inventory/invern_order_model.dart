// ignore_for_file: non_constant_identifier_names

import 'package:ku_animal_m/src/model/base_model.dart';

class InvenOrderModel extends BaseModel {
  String data = "";

  InvenOrderModel({required this.data});

  InvenOrderModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] ?? "";
    msg = json['msg'] ?? "";

    if (json['data'] != null) {
      data = json['data'] ?? "";
    }
  }
}
