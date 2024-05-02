// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

class Constants {
  // static const baseUrl = "http://kuvms.today25.com";
  static const baseUrl = "http://kuvms.konkuk.ac.kr";

  // api
  static const apiPrefix = "/Ajax/AjaxMobile";
  static const api_command = "$apiPrefix/reqRest";

  // 로그인
  static const api_login = "$apiPrefix/reqLogin";
  static const api_signup = "$apiPrefix/reqRegister";
  static const api_withdraw = "$apiPrefix/reqLeave";
  static const api_dashboard = "reqDashboard";

  // 홈화면 검색
  // sch_condition
  // - mi_code: 의약품코드
  // - mi_name : 의약품명
  // - mi_ingrmst_nameedients : 성분
  // - mi_manufacturer : 제조사
  // - mi_barcode : 바코드
  // sch_txt : 검색어
  // static const api_search = "$apiPrefix/reqSearchItems";
  // static const api_search = "$apiPrefix/reqSearchItems";
  static const api_search = "reqSearchItems";
  static const api_search_barcode = "reqSearchBarcode";

  // 재고관리
  static const api_product = "reqStock";
  static const api_product_order = "reqStockOrder";

  // 회원 > 로그인
  // static const api_qr_search = "reqUsers";

  // 회원 > 회원리스트
  static const api_client = "reqUsers";

  // 입고 > 입고등록
  static const api_product_in = "reqStockIn";

  // 입고 > 입고내역
  static const api_product_in_history = "reqStockHistory";

  // 출고 > 출고등록
  static const api_product_out = "reqStockOut";

  // 출고 > 출고내역
  static const api_product_out_history = "reqStockHistory";

  static List<String> filterList = ["filter name".tr, "filter code".tr, "filter element".tr, "filter company".tr];

  // month
  static List<String> monthList = [
    "jan".tr,
    "feb".tr,
    "mar".tr,
    "apr".tr,
    "may".tr,
    "jun".tr,
    "jul".tr,
    "aug".tr,
    "sep".tr,
    "oct".tr,
    "nov".tr,
    "dec".tr
  ];

  static const max_count = 999;
}
