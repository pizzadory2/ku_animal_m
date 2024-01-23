// ignore_for_file: constant_identifier_names

class Constants {
  static const baseUrl = "http://vmth.today25.com";

  // api
  static const apiPrefix = "/Ajax/AjaxMobile";
  // 로그인
  static const api_login = "$apiPrefix/reqLogin";
  static const api_dashboard = "$apiPrefix/reqAllSpace";

  // 홈화면 검색
  // sch_condition
  // - mi_code: 의약품코드
  // - mi_name : 의약품명
  // - mi_ingrmst_nameedients : 성분
  // - mi_manufacturer : 제조사
  // - mi_barcode : 바코드
  // sch_txt : 검색어
  static const api_search = "$apiPrefix/reqSearchItems";

  // 재고관리
  static const api_product = "$apiPrefix/reqStock";

  static const api_qr_search = "$apiPrefix/reqLogin";
  static const api_product_in = "$apiPrefix/reqLogin";
  static const api_product_in_history = "$apiPrefix/reqLogin";
  static const api_product_out = "$apiPrefix/reqLogin";
  static const api_product_out_history = "$apiPrefix/reqLogin";
  static const api_client = "$apiPrefix/reqLogin";
}
