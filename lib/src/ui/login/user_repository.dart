import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/common/constants.dart';
import 'package:ku_animal_m/src/model/base_model.dart';
import 'package:ku_animal_m/src/network/rest_client.dart';
import 'package:ku_animal_m/src/ui/login/user_model.dart';

class UserRepository {
  Future reqReadAll({required String thsSeq}) async {
    debugPrint("[animal] ::user_repository 디바이스 싹다가져와] API 호출");

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

  Future reqLogin(
      {required String id,
      required String pw,
      required String pushToken,
      required String deviceName,
      required String appVer}) async {
    debugPrint("[animal::user_repository] login API 호출");

    // FormData formData = FormData.fromMap({
    //   "user_id": id,
    //   "user_pw": pw,
    //   "push_token": pushToken,
    //   "device_name": deviceName,
    //   "app_ver": appVer,
    // });

    var param = {
      "userId": id,
      "userPw": pw,
      "pushToken": pushToken,
      "deviceName": deviceName,
      "appVer": appVer,
    };

    try {
      // var api = Constants.api_login;
      // var result = await RestClient().dio.post(
      //       api,
      //       options: Options(headers: {
      //         Headers.contentTypeHeader: "multipart/form-data",
      //       }),
      //       data: formData,
      //     );

      var api = Constants.api_login;
      var result = await RestClient().dio.post(
            api,
            options: Options(headers: {
              // Headers.contentTypeHeader: "multipart/form-data",
              Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
            }),
            data: param,
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

  Future reqSignup({
    required String id,
    required String pw,
    required String name,
    required String phone,
    required String email,
    required String type, // 근무 타입(PT:시간제, FT:계약직, NT:정규직)
  }) async {
    debugPrint("[animal::user_repository] login API 호출");

    var param = {
      "userId": id,
      "userPw": pw,
      "userName": name,
      "userPhone": phone,
      "userEmail": email,
      "workType": type,
    };

    try {
      var api = Constants.api_signup;
      var result = await RestClient().dio.post(
            api,
            options: Options(headers: {
              // Headers.contentTypeHeader: "multipart/form-data",
              Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
            }),
            data: param,
          );

      if (result != null) {
        var parseData = jsonDecode(result.toString());
        // var code = parseData["result"].toString();
        // var msg = parseData["msg"].toString();

        BaseModel apiResult = BaseModel.fromJson(parseData);

        // var data = UserInfoModel.fromJson(result.data);
        return apiResult;
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

  Future reqWithdraw({
    required String id,
    required String pw,
  }) async {
    debugPrint("[animal::user_repository] 회원탈퇴 API 호출");

    var param = {
      "userId": id,
      "userPw": pw,
    };

    try {
      var api = Constants.api_withdraw;
      var result = await RestClient().dio.post(
            api,
            options: Options(headers: {
              // Headers.contentTypeHeader: "multipart/form-data",
              Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
            }),
            data: param,
          );

      if (result != null) {
        var parseData = jsonDecode(result.toString());
        // var code = parseData["result"].toString();
        // var msg = parseData["msg"].toString();

        BaseModel apiResult = BaseModel.fromJson(parseData);

        // var data = UserInfoModel.fromJson(result.data);
        return apiResult;
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
