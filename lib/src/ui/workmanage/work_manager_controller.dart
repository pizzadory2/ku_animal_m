import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ku_animal_m/src/ui/workmanage/work_data_model.dart';
import 'package:ku_animal_m/src/ui/workmanage/work_manager_repository.dart';

class WorkManagerController extends GetxController {
  static WorkManagerController get to => Get.find();

  final WorkManagerRepository repository;
  WorkManagerController({required this.repository});

  RxBool isLoading = false.obs;

  List<WorkData> _list = [];

  clearData() {
    isLoading.value = true;
    _list.clear();

    isLoading.value = false;
    return true;
  }

  Future<bool> refreshData({int? year, int? month}) async {
    isLoading.value = true;
    bool isSuccess = false;

    String filterYear = (year != null) ? year.toString() : DateTime.now().year.toString();
    String filterMonth = (month != null) ? month.toString() : DateTime.now().month.toString();

    final WorkDataModel? resultModel = await repository.reqReadAll(year: filterYear, month: filterMonth);

    if (resultModel != null && resultModel.result == "SUCCESS") {
      // 데이터 초기화
      // _list.clear();
      _list = resultModel.workDatas;
      // _workDataMap.clear();

      // 맵에 날짜별로 WorkData 객체 저장
      // for (var work in _list) {
      //   if (work.date != null) {
      //     // 시간 정보가 포함된 DateTime에서 시간/분/초를 제거한 순수 날짜만 키로 사용
      //     DateTime pureDate = DateTime(work.date!.year, work.date!.month, work.date!.day);
      //     // _workDataMap[pureDate] = work;
      //   }
      // }
      isSuccess = true;
    } else {
      // 실패 시 에러 메시지 처리
      if (resultModel != null) {
        _showErrorSnackBar(resultModel.msg ?? "조회 실패");
      }
      isSuccess = false;
    }

    isLoading.value = false;
    return isSuccess;
  }

  // 에러 메시지 표시용 공통 함수 (예시)
  void _showErrorSnackBar(String message) {
    // 실제 사용하시는 UI 프레임워크의 스낵바 로직을 넣으세요
    // Get.snackbar("Error", message,
    //     snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    Get.snackbar("Error", message,
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  getCount() {
    return _list.length;
  }

  getItem(int index) {
    return _list[index];
  }

  getData(DateTime pureDate) {
    for (var element in _list) {
      if (element.date != null &&
          element.date!.year == pureDate.year &&
          element.date!.month == pureDate.month &&
          element.date!.day == pureDate.day) {
        return element;
      }
    }

    return null;
  }

  // void removeData(DateTime day) {
  //   _list.removeWhere((element) =>
  //       element.date != null &&
  //       element.date!.year == day.year &&
  //       element.date!.month == day.month &&
  //       element.date!.day == day.day);
  // }

  // 근무시간 데이터 업데이트(없으면 추가, 있으면 수정)
  // void updateData(DateTime day, String startStr, String endStr) {
  //   WorkData? existingData = getData(day);
  //   if (existingData != null) {
  //     // 수정
  //     existingData.start = startStr;
  //     existingData.end = endStr;
  //   } else {
  //     // 추가
  //     _list.add(WorkData(date: day, start: startStr, end: endStr, is_editable: true));
  //   }
  // }

  // WorkManagerController 내부

  Future<WorkDataModel?> saveAndRefreshBatch({
    required Set<DateTime> selectedDays,
    required String startStr,
    required String endStr,
    required int year,
    required int month,
  }) async {
    // 1. 데이터 포맷팅
    List<Map<String, String>> dataList = selectedDays
        .map((day) => {
              "date": DateFormat('yyyy-MM-dd').format(day),
              "start": startStr,
              "end": endStr,
            })
        .toList();

    // 2. Repository 호출
    final resultModel = await repository.reqSaveBatch(
      dataList: dataList,
      year: year,
      month: month,
    );

    if (resultModel != null && (resultModel.result == "SUCCESS" || resultModel.result == "PARTIAL")) {
      if (resultModel.details != null && resultModel.details!.isNotEmpty) {
        for (var detail in resultModel.details!) {
          // ⭐ 각 상세 항목의 result가 "SUCCESS"인 것만 골라서 업데이트
          if (detail.result == "SUCCESS" && detail.date != null) {
            DateTime date = DateTime.parse(detail.date!);
            _updateLocalList(date, startStr, endStr);
          }
        }
      } else if (resultModel.result == "SUCCESS") {
        // details가 없는데 전체 성공인 경우 기존처럼 전체 업데이트
        for (var day in selectedDays) {
          _updateLocalList(day, startStr, endStr);
        }
      }
      return resultModel;
    }
  }

  // WorkManagerController 내부

  Future<bool> deleteAndRefreshBatch({
    required Set<DateTime> selectedDays,
    required int year,
    required int month,
  }) async {
    // 1. 날짜 문자열 리스트 생성
    List<String> dateList = selectedDays.map((day) => DateFormat('yyyy-MM-dd').format(day)).toList();

    // 2. Repository 호출
    final resultModel = await repository.reqDeleteBatch(
      dateList: dateList,
      year: year,
      month: month,
    );

    // 3. 성공 시 로컬 데이터 삭제
    if (resultModel != null && resultModel.result == "SUCCESS") {
      for (var day in selectedDays) {
        _list.removeWhere(
            (item) => item.date?.year == day.year && item.date?.month == day.month && item.date?.day == day.day);
      }
      return true;
    }
    return false;
  }

  void _updateLocalList(DateTime day, String start, String end) {
    // 시간/분/초를 제외한 순수 날짜로 비교
    DateTime pureDate = DateTime(day.year, day.month, day.day);

    // 리스트에서 동일한 날짜가 있는지 찾기
    int index = _list.indexWhere((item) {
      if (item.date == null) return false;
      return item.date!.year == pureDate.year && item.date!.month == pureDate.month && item.date!.day == pureDate.day;
    });

    if (index != -1) {
      // 이미 있으면 해당 객체 수정
      _list[index].start = start;
      _list[index].end = end;
      _list[index].is_editable = true;
    } else {
      // 없으면 새 WorkData 추가
      _list.add(WorkData(
        date: pureDate,
        start: start,
        end: end,
        is_editable: true,
      ));
    }
  }

  bool existingData(DateTime day) {
    for (var element in _list) {
      if (element.date != null &&
          element.date!.year == day.year &&
          element.date!.month == day.month &&
          element.date!.day == day.day) {
        return true;
      }
    }

    return false;
  }

  bool isEditableData(DateTime dateTime) {
    for (var element in _list) {
      if (element.date != null &&
          element.date!.year == dateTime.year &&
          element.date!.month == dateTime.month &&
          element.date!.day == dateTime.day) {
        return element.is_editable;
      }
    }

    return true;
  }

  String get totalWorkTime {
    int totalMinutes = 0;

    for (var work in _list) {
      if (work.start.isNotEmpty && work.end.isNotEmpty) {
        try {
          // "HH:mm" 파싱
          List<String> startParts = work.start.split(':');
          List<String> endParts = work.end.split(':');

          int startHour = int.parse(startParts[0]);
          int startMin = int.parse(startParts[1]);
          int endHour = int.parse(endParts[0]);
          int endMin = int.parse(endParts[1]);

          int startTotal = (startHour * 60) + startMin;
          int endTotal = (endHour * 60) + endMin;

          // 종료 시간이 시작 시간보다 클 때만 더함
          if (endTotal > startTotal) {
            totalMinutes += (endTotal - startTotal);
          }
        } catch (e) {
          debugPrint("시간 파싱 에러: $e");
        }
      }
    }

    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;

    if (hours == 0 && minutes == 0) return "0시간";
    return minutes > 0 ? "$hours시간 $minutes분" : "$hours시간";
  }

  getAllDates() {
    Set<DateTime> dateSet = {};

    for (var element in _list) {
      if (element.date != null) {
        DateTime pureDate = DateTime(element.date!.year, element.date!.month, element.date!.day);
        dateSet.add(pureDate);
      }
    }

    return dateSet;
  }
}
