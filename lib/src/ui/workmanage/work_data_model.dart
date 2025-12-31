// ignore_for_file: non_constant_identifier_names

import 'package:intl/intl.dart';
import 'package:ku_animal_m/src/model/base_model.dart';

class WorkDataModel extends BaseModel {
  bool isEditable = true;
  List<WorkData> workDatas = [];

  // --- 저장 결과 전용 필드 추가 ---
  int? total;
  int? success;
  int? fail;
  List<SaveDetail>? details;

  WorkDataModel();

  WorkDataModel.fromJson(Map<String, dynamic> json) {
    result = json['result'] ?? "";
    msg = json['msg'] ?? "";

    // 1. json['data']가 null이 아니고 Map 타입인지 확인
    if (json['data'] != null && json['data'] is Map<String, dynamic>) {
      var data = json['data'] as Map<String, dynamic>;

      // 2. 조회 모드: data['result']가 List인지 확인
      if (data.containsKey('result') && data['result'] is List) {
        var list = data['result'] as List;
        workDatas = list.map((item) => WorkData.fromJson(item)).toList();
      }

      // 3. 저장 결과 필드 추출 (타입 캐스팅 추가)
      total = _toInt(data['total']);
      success = _toInt(data['success']);
      fail = _toInt(data['fail']);

      // 4. 상세 내역 처리
      if (data.containsKey('details') && data['details'] is List) {
        var detailList = data['details'] as List;
        details = detailList.map((item) => SaveDetail.fromJson(item)).toList();
      }
    }

    if (json['isEditable'] != null) {
      isEditable = json['isEditable'];
    }
  }

  // 숫자가 문자열로 올 경우를 대비한 헬퍼 함수
  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  clear() {
    workDatas = [];
    details = null;
  }
}

// 저장 시 각 날짜별 성공/실패 여부를 담는 클래스
class SaveDetail {
  int? index;
  String? date;
  String? uwts_seq;
  String? result;
  String? msg;

  SaveDetail.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    date = json['date'];
    uwts_seq = json['uwts_seq']?.toString();
    result = json['result'];
    msg = json['msg'];
  }
}

class WorkData {
  DateTime? date;
  String start = "";
  String end = "";
  bool is_editable = true;

  String? num;
  String? uwts_seq;
  String? tu_seq;
  String? uwts_work_time;
  String? uwts_work_memo;
  String? reg_date;
  String? tu_name;

  WorkData({
    this.date,
    this.start = "",
    this.end = "",
    this.is_editable = true,
    this.num,
    this.uwts_seq,
    this.tu_seq,
    this.uwts_work_time,
    this.uwts_work_memo,
    this.reg_date,
    this.tu_name,
  });

  WorkData.fromJson(Map<String, dynamic> json) {
    // 조회 시에는 uwts_start_time, 저장 결과 상세에서는 date 필드로 올 수 있음
    String startTimeFull = json['uwts_start_time'] ?? json['date'] ?? "";
    String endTimeFull = json['uwts_end_time'] ?? "";

    if (startTimeFull.isNotEmpty) {
      try {
        DateTime parsedDateTime = DateTime.parse(startTimeFull);
        date = DateTime(parsedDateTime.year, parsedDateTime.month, parsedDateTime.day);
        // "2025-11-16" 처럼 날짜만 오는 경우를 대비해 시간 파싱 시 에러 방지
        if (startTimeFull.contains(":")) {
          start = DateFormat('HH:mm').format(parsedDateTime);
        }
      } catch (e) {
        // 날짜 형식만 올 경우 (예: "2025-11-16") 처리
        date = DateTime.tryParse(startTimeFull);
      }
    }

    if (endTimeFull.isNotEmpty && endTimeFull.contains(":")) {
      try {
        DateTime parsedEndDateTime = DateTime.parse(endTimeFull);
        end = DateFormat('HH:mm').format(parsedEndDateTime);
      } catch (_) {}
    }

    num = json['num']?.toString();
    uwts_seq = json['uwts_seq']?.toString();
    tu_seq = json['tu_seq']?.toString();
    uwts_work_time = json['uwts_work_time'] ?? "";
    uwts_work_memo = json['uwts_work_memo'] ?? "";
    reg_date = json['reg_date'] ?? "";
    tu_name = json['tu_name'] ?? "";
    is_editable = json['is_editable'] ?? true;
  }
}
