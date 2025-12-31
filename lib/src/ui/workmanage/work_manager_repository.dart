import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/common/constants.dart';
import 'package:ku_animal_m/src/network/rest_client.dart';
import 'package:ku_animal_m/src/ui/workmanage/work_data_model.dart';

class WorkManagerRepository {
  Future<WorkDataModel?> reqReadAll({
    required String year,
    required String month,
  }) async {
    debugPrint("[animal]::WorkManager 근무시간 가져오기 호출");

    String month2 = month.padLeft(2, '0');

    var param = {
      "year": year,
      "month": month2,
      "command": Constants.api_work_history,
    };

    try {
      var response = await RestClient().dio.get(
            Constants.api_command,
            options: Options(headers: {
              Headers.contentTypeHeader: Headers.jsonContentType,
            }),
            queryParameters: param,
          );

      if (response.data != null) {
        dynamic jsonData = response.data;

        // 1. 만약 데이터가 String으로 들어왔다면 직접 jsonDecode 해줍니다.
        if (jsonData is String) {
          jsonData = jsonDecode(jsonData);
        }

        // 2. 이제 jsonData는 확실히 Map<String, dynamic> 이므로 모델에 넣습니다.
        var model = WorkDataModel.fromJson(jsonData);

        // 2. SUCCESS 여부 체크
        if (model.result == "SUCCESS") {
          return model;
        } else {
          // FAIL일 경우 서버에서 온 메시지를 포함한 모델 반환
          debugPrint("조회 실패 메시지: ${model.msg}");
          return model;
        }
      }
    } on DioException catch (e) {
      debugPrint("Dio 에러: ${e.message}");
      // 에러 발생 시에도 적절한 처리를 위해 null 반환 혹은 커스텀 에러 모델 반환
    }
    return null;
  }

  Future<WorkDataModel?> reqSaveBatch({
    required List<Map<String, String>> dataList,
    required int year,
    required int month,
  }) async {
    debugPrint("[animal]::WorkManager 저장 API 호출 (form-urlencoded)");

    // 1. 기본 파라미터 구성
    Map<String, dynamic> param = {
      "command": Constants.api_work_save,
      "year": year.toString(),
      "month": month.toString(),
    };

    // 2. dataList를 서버가 원하는 키 포맷으로 변환
    // 예: data[0][date], data[0][start] ...
    for (int i = 0; i < dataList.length; i++) {
      param["data[$i][date]"] = dataList[i]['date'];
      param["data[$i][start]"] = dataList[i]['start'];
      param["data[$i][end]"] = dataList[i]['end'];
    }

    try {
      var response = await RestClient().dio.post(
            Constants.api_command,
            data: param, // Map을 그대로 전달
            options: Options(
              headers: {
                // ⭐ Content-Type을 x-www-form-urlencoded로 설정
                Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
              },
            ),
          );

      // 응답 처리 (이전 로직 유지)
      var jsonData = response.data is String ? jsonDecode(response.data) : response.data;
      return WorkDataModel.fromJson(jsonData);
    } on DioException catch (e) {
      debugPrint("저장 통신 에러: ${e.message}");
      return null;
    }
  }

  Future<WorkDataModel?> reqDeleteBatch({
    required List<String> dateList, // 삭제할 날짜 문자열 리스트 (yyyy-MM-dd)
    required int year,
    required int month,
  }) async {
    debugPrint("[animal]::WorkManager 삭제 API 호출");

    // 1. 기본 파라미터 구성
    Map<String, dynamic> param = {
      "command": Constants.api_work_delete, // 서버와 협의된 삭제 커맨드명
      "year": year.toString(),
      "month": month.toString(),
    };

    // 2. data[i][date] 형식으로 날짜들만 구성
    for (int i = 0; i < dateList.length; i++) {
      param["data[$i][date]"] = dateList[i];
    }

    try {
      var response = await RestClient().dio.post(
            Constants.api_command,
            data: param,
            options: Options(
              headers: {
                Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
              },
            ),
          );

      var jsonData = response.data is String ? jsonDecode(response.data) : response.data;
      return WorkDataModel.fromJson(jsonData);
    } catch (e) {
      debugPrint("Repository 삭제 에러: $e");
      return null;
    }
  }

  // reqSaveData({required List<OrderModel> list}) async {
  //   List<String> reqSeqList = list.map((e) => e.code).toList();
  //   List<String> countList = list.map((e) => e.orderCount.toString()).toList();

  //   var param = {
  //     "command": Constants.api_product_order_inven,
  //     "req_seq_list[]": reqSeqList,
  //     "req_qty_list[]": countList,
  //   };

  //   debugPrint(jsonEncode(param).toString());

  //   try {
  //     var result = await RestClient().dio.post(
  //           Constants.api_command,
  //           options: Options(headers: {
  //             Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
  //             // Headers.contentTypeHeader: "multipart/form-data",
  //             // Headers.contentTypeHeader: "application/json",
  //             // Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
  //           }),
  //           data: param,
  //           // data: jsonEncode(param),
  //         );

  //     if (result != null) {
  //       if (result.data != null) {}

  //       var parseData = jsonDecode(result.toString());
  //       // var code = parseData["result"].toString();
  //       // var msg = parseData["msg"].toString();
  //       // if (parseData["result"] != "SUCCESS") {
  //       //   return null;
  //       // }

  //       // ProductRegModel resultModel = ProductRegModel.fromJson(parseData);
  //       InvenOrderModel resultModel = InvenOrderModel.fromJson(parseData);

  //       return resultModel;
  //     } else {
  //       return null; // Map()
  //     }
  //   } on DioException catch (e) {
  //     if (e.response != null) {
  //       debugPrint(e.response!.data.toString());
  //       debugPrint(e.response!.headers.toString());
  //       // debugPrint(e.response!.requestOptions.toString());
  //     } else {
  //       // Something happened in setting up or sending the request that triggered an Error
  //       // debugPrint(e.requestOptions.toString());
  //       debugPrint(e.message);
  //     }
  //   }

  //   return null;
  // }
}
