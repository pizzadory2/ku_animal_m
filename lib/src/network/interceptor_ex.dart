// import 'dart:convert';

import 'package:dio/dio.dart';
// import 'package:get/get.dart' hide Response;
import 'package:flutter/material.dart';

class InterceptorEx extends Interceptor {
  // final Dio _dio;
  // InterceptorEx(this._dio);
  InterceptorEx();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.data}');
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // debugPrint("RESPONSE-Data: ${response.data}");
    debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

    // final responseBody = jsonDecode(response.toString());
    // var profileDetected = responseBody["profileDetected"];

    // if (responseBody['code'] == "SI000") {
    //   var object = responseBody['object'];
    //   EmergencyModel model = EmergencyModel.fromJson(object);
    //   BuildContext context = Get.key.currentContext!;
    //   showEmergencyDialog(context, model, onClose: () {});
    //   return;
    // }

    handler.next(response);
    // if (profileDetected == true) {
    //   ProfileController.to.requestMyProfileInfo();
    //   MembershipController.to.requestMyMembership();
    //   ProfileController.to.requestProfilePanel();
    // }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    debugPrint('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    debugPrint('ERROR[${err.response?.data.toString()}]');

    switch (err.type) {
      case DioExceptionType.badCertificate:
        break;
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        // throw DeadlineExceededException(err.requestOptions);
        return handler.next(err);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            throw BadRequestException(err.requestOptions);
          case 401:
            {
              // throw UnauthorizedException(err.requestOptions);
              // final accessToken = Preference().getString("token");
              // final refreshToken = Preference().getString("refreshToken");

              // debugPrint("[API 인증 오류(401)] - 액세스:$accessToken / 리프레쉬:$refreshToken");

              // var refreshDio = Dio(
              //   BaseOptions(
              //     baseUrl: "http://3.35.195.160:8010",
              //     receiveTimeout: 5 * 1000,
              //     connectTimeout: 5 * 1000,
              //     sendTimeout: 10 * 1000,
              //   ),
              // );
              // refreshDio.interceptors.clear();
              // refreshDio.interceptors.add(InterceptorsWrapper(onError: (error, handler) async {
              //   if (error.response?.statusCode == 401 || error.response?.statusCode == 403) {
              //     print("ERROR[${error.response?.statusCode}] - 토큰갱신시도 실패");
              //     UserController.to.logout();
              //     // UserController.to.removeToken();
              //     // Get.offAllNamed(RouteList.SIGNUP_SNS);
              //   }

              //   return handler.next(error);
              // }));

              // var sendData = {
              //   "refreshToken": refreshToken,
              // };

              // var res = await refreshDio.post(
              //   '/cero/v1/auth/refresh/authorize',
              //   options: Options(headers: {
              //     Headers.contentTypeHeader: Headers.formUrlEncodedContentType,
              //   }),
              //   data: sendData,
              // );

              // if (res.data != null) {
              //   var data = LoginModel.fromJson(res.data);
              //   var token = data.result!.token;
              //   var rToken = data.result!.refreshToken;
              //   Preference().setData("token", token);
              //   Preference().setData("refreshToken", rToken);
              //   _dio.options.headers["Authorization"] = "Bearer $token";

              //   print(data);
              //   // 수행하지 못했던 API 요청 복사본 생성
              //   final clonedRequest = await _dio.request(err.requestOptions.path,
              //       options: Options(method: err.requestOptions.method, headers: err.requestOptions.headers),
              //       data: err.requestOptions.data,
              //       queryParameters: err.requestOptions.queryParameters);

              //   // API 복사본으로 재요청
              //   return handler.resolve(clonedRequest);
              // } else {
              //   UserController.to.logout();
              //   // Get.offAllNamed(RouteList.SIGNUP_SNS);
              // }
              // Util.showToast("토큰이 만료되었습니다\n다시 로그인해주세요");
              // UserController.to.logout();
            }
            break;
          case 403:
            {
              // throw UnauthorizedException(err.requestOptions);
              // Util.showToast("토큰이 만료되었습니다\n다시 로그인해주세요");
              // UserController.to.logout();
              // UserController.to.removeToken();
              // Get.offAllNamed(RouteList.SIGNUP_SNS);
            }
            break;
          case 404:
            return handler.next(err);
          // throw NotFoundException(err.requestOptions);
          case 409:
            throw ConflictException(err.requestOptions);
          case 500:
            return handler.next(err);
          //throw InternalServerErrorException(err.requestOptions);
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
        break;
      // throw NoInternetConnectionException(err.requestOptions);
    }

    handler.next(err);
  }
}

class BadRequestException extends DioException {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioException {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioException {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
