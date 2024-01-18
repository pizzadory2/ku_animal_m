// ignore_for_file: non_constant_identifier_names

import 'package:ku_animal_m/src/model/base_model.dart';

class HomeModel extends BaseModel {
  UserData data = UserData();

  HomeModel({required this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    // if (json['data'] != null) {
    //   resultMsg = json['result'] ?? "";
    //   msg = json['msg'] ?? "";
    // }
    result = json['result'] ?? "";
    msg = json['msg'] ?? "";

    // data = json['data'] != null ? UserData.fromJson(json['data']) : UserData();
    if (json['data'] != null) {
      data = UserData.fromJson(json['data']);
    }
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   if (result != null) {
  //     data['data'] = result!.toJson();
  //   }
  //   return data;
  // }
}

class UserData {
  String tu_seq = "";
  String tu_id = "";
  String tu_name = "";

  UserData({this.tu_seq = "", this.tu_id = "", this.tu_name = ""});

  UserData.fromJson(Map<String, dynamic> json) {
    tu_seq = json['tu_seq'] ?? "";
    tu_id = json['tu_id'] ?? "";
    tu_name = json['tu_name'] ?? "";
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['id'] = id;
  //   data['refreshToken'] = tokenRefresh;
  //   data['jwtToken'] = tokenJWT;
  //   data['email'] = email;
  //   data['nick'] = nick;
  //   data['grade'] = grade;
  //   data['birth'] = birth;

  //   return data;
  // }

  clear() {
    tu_seq = "";
    tu_id = "";
    tu_name = "";
  }
}
