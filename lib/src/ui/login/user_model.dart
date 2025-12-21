// ignore_for_file: non_constant_identifier_names

import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/model/base_model.dart';

class UserModel extends BaseModel {
  UserData data = UserData();
  // String? resultMsg;
  // String? msg;

  UserModel({required this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
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
  String seq = "";
  String id = "";
  String name = "";
  String type = "";
  String token = "";

  // 메뉴권한
  bool clientList = false; // "EMPLOYEE_10_10": "N", // 회원리스트
  bool clientLevel = false; // "EMPLOYEE_10_20": "N", // 회원권한
  bool workManage = false; // "": "N", // 근무관리
  bool outReg = false; // "ISSUE_10_10": "Y",    // 출고등록
  bool outList = false; // "ISSUE_10_20": "Y",    // 출고내역
  bool productReg = false; // "ITEM_10_10": "N",     // 약품등록
  bool productList = false; // "ITEM_10_20": "N",     // 약품리스트
  bool companyList = false; // "PARTNER_10_10": "N",  // 협력업체리스트
  bool inReg = false; // "RECEIPT_10_10": "Y",  // 입고등록
  bool inList = false; // "RECEIPT_10_20": "Y",  // 입고내역
  bool orderReg = false; // "REPORT_10_10": "N",   // 발주등록
  bool orderList = false; // "REPORT_10_20": "N",   // 발주리스트
  bool invenList = false; // "STOCK_10_10": "Y",    // 재고리스트
  bool payReg = false; // "STOCK_10_20": "N",    // 수불처리
  bool warehouseList = false; // "WAREHOUSE_10_10": "N" // 창고리스트

  UserData({this.seq = "", this.id = "", this.name = "", this.type = "", this.token = ""});

  UserData.fromJson(Map<String, dynamic> json) {
    seq = json['seq'] ?? "";
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    type = json['type'] ?? "";
    token = json['token'] ?? "";

    var grantList = json["grant"];
    if (grantList != null) {
      // grand = List<GrandModel>.from(grandList.map((model) => GrandModel.fromJson(model)));
      clientList = Utils.YN2Bool(grantList['EMPLOYEE_10_10']); // 회원리스트
      clientLevel = Utils.YN2Bool(grantList['EMPLOYEE_10_20']); // 회원권한
      outReg = Utils.YN2Bool(grantList['ISSUE_10_10']); // 출고등록
      outList = Utils.YN2Bool(grantList['ISSUE_10_20']); // 출고내역
      productReg = Utils.YN2Bool(grantList['ITEM_10_10']); // 약품등록
      productList = Utils.YN2Bool(grantList['ITEM_10_20']); // 약품리스트
      companyList = Utils.YN2Bool(grantList['PARTNER_10_10']); // 협력업체리스트
      inReg = Utils.YN2Bool(grantList['RECEIPT_10_10']); // 입고등록
      inList = Utils.YN2Bool(grantList['RECEIPT_10_20']); // 입고내역
      orderReg = Utils.YN2Bool(grantList['REPORT_10_10']); // 발주등록
      orderList = Utils.YN2Bool(grantList['REPORT_10_20']); // 발주리스트
      invenList = Utils.YN2Bool(grantList['STOCK_10_10']); // 재고리스트
      payReg = Utils.YN2Bool(grantList['STOCK_10_20']); // 수불처리
      warehouseList = Utils.YN2Bool(grantList['WAREHOUSE_10_10']); // 창고리스트
    }
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
    seq = "";
    id = "";
    name = "";
    type = "";

    clientList = false;
    clientLevel = false;
    outReg = false;
    outList = false;
    productReg = false;
    productList = false;
    companyList = false;
    inReg = false;
    inList = false;
    orderReg = false;
    orderList = false;
    invenList = false;
    payReg = false;
    warehouseList = false;
  }
}
