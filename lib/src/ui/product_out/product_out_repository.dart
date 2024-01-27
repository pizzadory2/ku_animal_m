import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/common/constants.dart';
import 'package:ku_animal_m/src/network/rest_client.dart';
import 'package:ku_animal_m/src/ui/product/product_history_model.dart';

class ProductOutRepository {
  Future reqReadAll({
    required String year,
    required String month,
    String gubun = "",
    String type = "",
    String txt = "",
  }) async {
    debugPrint("[animal] ::Product 제품정보 싹다가져와] API 호출");

    String month2 = month.padLeft(2, '0');

    var param = {
      "sch_year": year,
      "sch_month": month2,
      "sch_class": gubun,
      "sch_type": type,
      "sch_txt": txt,
      "msr_type": "OUT", // [필수] IN: 입고내역, OUT: 출고내역
      "command": Constants.api_product_out_history
    };

    try {
      var result = await RestClient().dio.get(
            Constants.api_command,
            options: Options(headers: {
              Headers.contentTypeHeader: Headers.jsonContentType,
              // Headers.contentTypeHeader: Headers.textPlainContentType,
            }),
            queryParameters: param,
            // data: jsonEncode(param),
          );

      if (result.data != null) {
        var parseData = jsonDecode(result.toString());
        // var code = parseData["result"].toString();
        // var msg = parseData["msg"].toString();
        var dataList = parseData["data"];
        // debugPrint(dataList.toString());

        List<ProductHistoryModel> items =
            List<ProductHistoryModel>.from(dataList.map((model) => ProductHistoryModel.fromJson(model)));

        // // var data = UserInfoModel.fromJson(result.data);
        // return items;
        return items;
      } else {
        return null; // Map()
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        // debugPrint(e.response!.requestOptions.toString());
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
      }
    }

    return null;
  }

  Future reqSearchBarcode({
    required String year,
    required String month,
    String gubun = "",
    String type = "mst_barcode",
    String txt = "",
  }) async {
    debugPrint("[animal] ::Product 제품정보 싹다가져와] API 호출");

    String month2 = month.padLeft(2, '0');

    var param = {
      "sch_year": year,
      "sch_month": month2,
      "sch_class": gubun,
      "sch_type": type,
      "sch_text": txt,
      "command": Constants.api_product,
    };

    try {
      var result = await RestClient().dio.get(
            Constants.api_command,
            options: Options(headers: {
              // Headers.contentTypeHeader: Headers.jsonContentType,
              Headers.contentTypeHeader: Headers.textPlainContentType,
            }),
            queryParameters: param,
            // data: jsonEncode(param),
          );

      if (result.data != null) {
        var parseData = jsonDecode(result.toString());
        // var code = parseData["result"].toString();
        // var msg = parseData["msg"].toString();
        var dataList = parseData["data"];
        // debugPrint(dataList.toString());

        List<ProductHistoryModel> items =
            List<ProductHistoryModel>.from(dataList.map((model) => ProductHistoryModel.fromJson(model)));

        // // var data = UserInfoModel.fromJson(result.data);
        // return items;
        return items;
      } else {
        return null; // Map()
      }
    } on DioException catch (e) {
      if (e.response != null) {
        debugPrint(e.response!.data.toString());
        debugPrint(e.response!.headers.toString());
        // debugPrint(e.response!.requestOptions.toString());
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        // debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
      }
    }

    return null;
  }
}
