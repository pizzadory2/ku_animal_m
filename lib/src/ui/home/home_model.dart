// ignore_for_file: non_constant_identifier_names

import 'package:ku_animal_m/src/model/base_model.dart';

class HomeModel extends BaseModel {
  MonthData monthData = MonthData();
  ItemStatusData itemStatusData = ItemStatusData();
  List<RecentData> recentDatas = [];

  HomeModel();
  // HomeModel({required this.data});

  HomeModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] ?? "";
    msg = json['msg'] ?? "";

    // data = json['data'] != null ? UserData.fromJson(json['data']) : UserData();
    if (json['data'] != null) {
      monthData = MonthData.fromJson(json['data']);
      itemStatusData = ItemStatusData.fromJson(json['data']);
      if (json['data']['recentItems'] != null) {
        recentDatas = List<RecentData>.from(json['data']['recentItems'].map((model) => RecentData.fromJson(model)));
      }
    }
  }

  clear() {
    monthData = MonthData();
    itemStatusData = ItemStatusData();
    recentDatas = [];
  }
}

class MonthData {
  int inCount = 0;
  int outCount = 0;
  String start = "";
  String end = "";

  MonthData({this.inCount = 0, this.outCount = 0, this.start = "", this.end = ""});

  MonthData.fromJson(Map<String, dynamic> json) {
    if (json["monthStatus"] != null) {
      inCount = json['monthStatus']['in'] ?? 0;
      outCount = json['monthStatus']['out'] ?? 0;
      start = json['monthStatus']['start'] ?? "";
      end = json['monthStatus']['end'] ?? "";
    }
  }
}

class ItemStatusData {
  int safeCount = 0;
  int totalCount = 0;

  ItemStatusData({this.safeCount = 0, this.totalCount = 0});

  ItemStatusData.fromJson(Map<String, dynamic> json) {
    if (json["itemStatus"] != null) {
      var safe = json['itemStatus']['safe'] ?? "0";
      var total = json['itemStatus']['total'] ?? "0";

      safeCount = int.parse(safe);
      totalCount = int.parse(total);
    }
  }
}

class RecentData {
  String mi_code = "";
  String mi_name = "";
  String msr_type = "";
  String msr_qty = "";
  String msr_man = "";
  String msr_date = "";

  RecentData({
    this.mi_code = "",
    this.mi_name = "",
    this.msr_type = "",
    this.msr_qty = "",
    this.msr_man = "",
    this.msr_date = "",
  });

  RecentData.fromJson(Map<String, dynamic> json) {
    mi_code = json['mi_code'] ?? "";
    mi_name = json['mi_name'] ?? "";
    msr_type = json['msr_type'] ?? "";
    msr_qty = json['msr_qty'] ?? "";
    msr_man = json['msr_man'] ?? "";
    msr_date = json['msr_date'] ?? "";
  }
}
