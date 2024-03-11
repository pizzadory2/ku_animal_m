import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ku_animal_m/src/common/preference.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/network/interceptor_ex.dart';

class RestClient {
  // variable
  int _testVariable = 0;
  int get testVariable => _testVariable;
  set testVariable(int value) => testVariable = value;
  void increaseVariable() => _testVariable++;
  //

  final dio = createDio();

  RestClient._internal();

  static final _instance = RestClient._internal();

  factory RestClient() => _instance;

  static createDio() {
    String apiUrl = AppController.to.serverUrl;
    debugPrint("[RestClient] 디오 생성 apiUrl: $apiUrl");

    var dio = Dio(
      BaseOptions(
        baseUrl: apiUrl, // 에뮬에서는 10.0.2.2가 localhost임 // 사무실에서 동작 안함
        // receiveTimeout: const Duration(milliseconds: 10),
        // connectTimeout: const Duration(milliseconds: 10),
        // sendTimeout: const Duration(milliseconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {'Authorization': 'Bearer asdfasdfasdf'},
      ),
    );

    // dio.interceptors.add(InterceptorEx(dio));
    dio.interceptors.add(InterceptorEx());

    return dio;
  }

  updateDio(String serverIP) {
    String apiUrl = serverIP;
    debugPrint("[RestClient] 디오 정보 업데이트 apiUrl: $apiUrl");

    dio.options.baseUrl = apiUrl;

    AppController.to.serverUrl = apiUrl;
    Preference().setData("ip", apiUrl);
  }

  setToken(String token) {
    debugPrint("[RestClient] [animal] 토큰설정 -> $token");
    dio.options.headers["Authorization"] = "Bearer $token";
  }

  removeToken() {
    debugPrint("[RestClient] 토큰삭제");
    dio.options.headers["Authorization"] = "";
  }

  dioExcept(DioException e) {
    if (e.response != null) {
      debugPrint(e.response?.data);
      debugPrint(e.response?.headers.toString());
      debugPrint(e.response?.requestOptions.toString());
    } else {
      // Something happened in setting up or sending the request that triggered an Error
      debugPrint(e.requestOptions.toString());
      debugPrint(e.message);
    }
  }
}
