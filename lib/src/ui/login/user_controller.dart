import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/preference.dart';
import 'package:ku_animal_m/src/model/base_model.dart';
import 'package:ku_animal_m/src/network/rest_client.dart';
import 'package:ku_animal_m/src/ui/login/user_model.dart';
import 'package:ku_animal_m/src/ui/login/user_repository.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final UserRepository repository;
  UserController({required this.repository});

  RxBool isLoading = false.obs;

  String userName = "Samantha";
  String userSeq = "";
  String userID = "";
  String userPW = "";
  String userToken = "";
  UserData userData = UserData();

  Future<bool> login(
      {required String id,
      required String pw,
      required String pushToken,
      required String deviceName,
      required String appVer}) async {
    // return Future.delayed(const Duration(seconds: 1), () {
    //   return true;
    // });

    isLoading.value = true;
    bool isSuccess = false;
    String resultMsg = "네트워크 상태를 확인해주세요.";

    clear();

    debugPrint("[animal] 로그인로그인로그인777777777777777");

    await repository
        .reqLogin(id: id, pw: pw, pushToken: pushToken, deviceName: deviceName, appVer: appVer)
        .then((value) {
      isLoading.value = false;

      if (value != null) {
        if (value is UserModel) {
          debugPrint("value is UserModel");

          resultMsg = value.msg ?? "";

          if (value.result == "SUCCESS") {
            userData = value.data;

            userName = userData.name;
            // className = value.className;
            // classSeq = value.result.tu_seq;
            // className = value.result.tu_class_seq;
            // userSeq = int.parse(value.data.seq);
            userSeq = userData.seq;
            userID = id;
            userPW = pw;
            userToken = userData.token;

            RestClient().setToken(userToken);

            isSuccess = true;
          } else {
            isSuccess = false;
          }
        } else {
          debugPrint("value is not UserModel");
          isSuccess = false;
        }
      } else {
        isSuccess = false;
        // resultMsg = "네트워크 상태를 확인해주세요.";
        // Get.snackbar("login failed".tr, resultMsg);
      }
    });

    if (isSuccess == false) {
      // Utils.showToast(resultMsg);
      Get.snackbar("login failed".tr, resultMsg);
    }

    return isSuccess;
  }

  Future<bool> singup(
      {required String id,
      required String pw,
      required String name,
      required String phone,
      required String email,
      required String type}) async {
    // return Future.delayed(const Duration(seconds: 1), () {
    //   return true;
    // });

    isLoading.value = true;
    bool isSuccess = false;
    String resultMsg = "네트워크 상태를 확인해주세요.";

    clear();

    debugPrint("[animal] 회원가입777777777777777");

    await repository.reqSignup(id: id, pw: pw, name: name, phone: phone, email: email, type: type).then((value) {
      isLoading.value = false;

      if (value != null) {
        if (value is BaseModel) {
          debugPrint("value is BaseModel");

          resultMsg = value.msg ?? "";

          if (value.result == "SUCCESS") {
            isSuccess = true;
          } else {
            if (value.result == "REQUIRED") {
              // String missItem = value.data ?? "";
              resultMsg = "필수항목을 입력해주세요.";
            }
            isSuccess = false;
          }
        } else {
          debugPrint("value is not UserModel");
          isSuccess = false;
        }
      } else {
        isSuccess = false;
        // resultMsg = "네트워크 상태를 확인해주세요.";
        // Get.snackbar("login failed".tr, resultMsg);
      }
    });

    if (isSuccess == false) {
      // Utils.showToast(resultMsg);
      Get.snackbar("signup failed".tr, resultMsg);
    }

    return isSuccess;
  }

  // 회원탈퇴
  Future<bool> withdraw({required String id, required String pw}) async {
    // return Future.delayed(const Duration(seconds: 1), () {
    //   return true;
    // });

    isLoading.value = true;
    bool isSuccess = false;
    String resultMsg = "네트워크 상태를 확인해주세요.";

    clear();

    debugPrint("[animal] 회원탈퇴777777777777777");

    await repository.reqWithdraw(id: id, pw: pw).then((value) {
      isLoading.value = false;

      if (value != null) {
        if (value is BaseModel) {
          debugPrint("value is BaseModel");

          resultMsg = value.msg ?? "";

          if (value.result == "SUCCESS") {
            isSuccess = true;
          } else {
            if (value.result == "REQUIRED") {
              // String missItem = value.data ?? "";
              resultMsg = "비밀번호를 다시 입력해주세요.";
            }
            isSuccess = false;
          }
        } else {
          debugPrint("value is not UserModel");
          isSuccess = false;
        }
      } else {
        isSuccess = false;
        // resultMsg = "네트워크 상태를 확인해주세요.";
        // Get.snackbar("login failed".tr, resultMsg);
      }
    });

    if (isSuccess == false) {
      // Utils.showToast(resultMsg);
      Get.snackbar("withdraw failed".tr, resultMsg);
    }

    return isSuccess;
  }

  void clear() {
    userName = "";
    userSeq = "";
    userID = "";
    userPW = "";

    userData.clear();
  }

  void logout() {
    Preference().setString("userId", "");
    Preference().setString("userPw", "");
    RestClient().removeToken();

    clear();
  }
}
