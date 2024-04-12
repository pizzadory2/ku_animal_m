import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/common/constants.dart';
import 'package:ku_animal_m/src/model/base_model.dart';
import 'package:ku_animal_m/src/network/rest_client.dart';
import 'package:ku_animal_m/src/ui/inventory/invern_order_model.dart';
import 'package:ku_animal_m/src/ui/inventory/order_model.dart';
import 'package:ku_animal_m/src/ui/product/inven_model.dart';

class InvenRepository {
  Future reqReadAll({
    required String year,
    required String month,
    String gubun = "",
    String type = "",
    String txt = "",
  }) async {
    debugPrint("[animal] ::InvenRepository 제품정보 싹다가져와] API 호출");

    String month2 = month.padLeft(2, '0');

    var param = {
      "sch_year": year,
      "sch_month": month2,
      "sch_class": gubun,
      "sch_type": type,
      "sch_txt": txt,
      "command": Constants.api_product,
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

        List<InvenModel> items = List<InvenModel>.from(dataList.map((model) => InvenModel.fromJson(model)));

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
    debugPrint("[animal] ::InvenRepository 제품정보 싹다가져와] API 호출");

    String month2 = month.padLeft(2, '0');

    var param = {
      "sch_year": year,
      "sch_month": month2,
      "sch_class": gubun,
      "sch_type": type,
      "sch_txt": txt,
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

        List<InvenModel> items = List<InvenModel>.from(dataList.map((model) => InvenModel.fromJson(model)));

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

  reqStockOrder({required List<OrderModel> list, required String msg, required String reason}) async {
    List<String> miCodeList = list.map((e) => e.code).toList();
    List<String> countList = list.map((e) => e.orderCount.toString()).toList();
    List<String> filePathList = list.map((e) => e.filePath.toString()).toList();

    var param = {
      "command": Constants.api_product_order,
      "msor_title": msg,
      "mi_code[]": miCodeList,
      "msor_req_stock[]": countList,
      "msor_reason": reason,
    };

    List<MultipartFile> _files = [];
    if (filePathList.isNotEmpty) {
      for (int i = 0; i < filePathList.length; i++) {
        if (filePathList[i].contains("http") || filePathList[i].isEmpty) {
          continue;
        } else {
          _files.add(MultipartFile.fromFileSync(filePathList[i]));
        }
      }
      // List<MultipartFile> _files = imagePaths.map((e) => MultipartFile.fromFileSync(e)).toList();
      // _files = imagePaths.map((e) => MultipartFile.fromFileSync(e)).toList();
    }

    FormData formData = FormData.fromMap({
      "command": Constants.api_product_order,
      "msor_title": msg,
      "mi_code[]": miCodeList,
      "msor_req_stock[]": countList,
      "msor_reason": reason,
    });

    for (int i = 0; i < _files.length; i++) {
      formData.files.add(MapEntry("file${i + 1}", _files[i]));
    }

    debugPrint(jsonEncode(param).toString());

    try {
      var result = await RestClient().dio.post(
            Constants.api_command,
            options: Options(headers: {
              Headers.contentTypeHeader: "multipart/form-data",
              // Headers.contentTypeHeader: "application/json",
              // Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
            }),
            data: formData,
            // data: jsonEncode(param),
          );

      if (result != null) {
        if (result.data != null) {
          int a = 0;
          a++;
        }

        var parseData = jsonDecode(result.toString());
        // var code = parseData["result"].toString();
        // var msg = parseData["msg"].toString();
        // if (parseData["result"] != "SUCCESS") {
        //   return null;
        // }

        // ProductRegModel resultModel = ProductRegModel.fromJson(parseData);
        InvenOrderModel resultModel = InvenOrderModel.fromJson(parseData);

        return resultModel;
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
