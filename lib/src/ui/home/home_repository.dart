import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/common/constants.dart';
import 'package:ku_animal_m/src/network/rest_client.dart';
import 'package:ku_animal_m/src/ui/login/user_model.dart';

class HomeRepository {
  Future reqReadAll({required String thsSeq}) async {
    debugPrint("[ku_pad::user_repository 디바이스 싹다가져와] API 호출");

    var param = {
      "ths_seq": thsSeq,
    };

    try {
      var api = "/reqDeviceList";
      var result = await RestClient().dio.get(
            api,
            options: Options(headers: {
              Headers.contentTypeHeader: Headers.jsonContentType,
            }),
            queryParameters: param,
            // data: jsonEncode(param),
          );

      if (result.data != null) {
        var parseData = jsonDecode(result.toString());
        // var code = parseData["result"].toString();
        // var msg = parseData["msg"].toString();
        var dataList = parseData["data"];
        debugPrint(dataList.toString());

        // List<DeviceModel> items = List<DeviceModel>.from(dataList.map((model) => DeviceModel.fromJson(model)));

        // // var data = UserInfoModel.fromJson(result.data);
        // return items;
        return null;
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

  Future reqLogin({required String id, required String pw}) async {
    debugPrint("[animal::user_repository] login API 호출");

    FormData formData = FormData.fromMap({
      "user_id": id,
      "user_pw": pw,
    });

    try {
      var api = Constants.api_login;
      var result = await RestClient().dio.post(
            api,
            options: Options(headers: {
              Headers.contentTypeHeader: "multipart/form-data",
            }),
            data: formData,
          );

      if (result != null) {
        var parseData = jsonDecode(result.toString());
        // var code = parseData["result"].toString();
        // var msg = parseData["msg"].toString();

        UserModel userModel = UserModel.fromJson(parseData);

        // var data = UserInfoModel.fromJson(result.data);
        return userModel;
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

  loadAll({required String userSeq}) async {
    debugPrint("[animal::home_repository(대쉬보드)] dashboard API 호출");

    // var param = {
    //   "ths_seq": thsSeq,
    // };

    try {
      var api = Constants.api_dashboard;
      var result = await RestClient().dio.get(
            api,
            options: Options(headers: {
              Headers.contentTypeHeader: Headers.jsonContentType,
            }),
            // queryParameters: param,
          );

      if (result != null) {
        var parseData = jsonDecode(result.toString());
        // var code = parseData["result"].toString();
        // var msg = parseData["msg"].toString();

        UserModel userModel = UserModel.fromJson(parseData);

        // var data = UserInfoModel.fromJson(result.data);
        return userModel;
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
