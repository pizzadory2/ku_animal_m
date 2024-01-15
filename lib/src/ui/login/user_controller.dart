import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/ui/login/user_model.dart';
import 'package:ku_animal_m/src/ui/login/user_repository.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final UserRepository repository;
  UserController({required this.repository});

  RxBool isLoading = false.obs;

  String userName = "Samantha";
  int userSeq = -1;
  String userID = "";
  String userPW = "";

  Future<bool> login({required String id, required String pw}) async {
    // return Future.delayed(const Duration(seconds: 1), () {
    //   return true;
    // });

    isLoading.value = true;
    bool isSuccess = false;
    String resultMsg = "네트워크 상태를 확인해주세요.";

    clear();

    debugPrint("[animal] 로그인로그인로그인777777777777777");

    await repository.reqLogin(id: id, pw: pw).then((value) {
      isLoading.value = false;

      if (value != null) {
        if (value is UserModel) {
          debugPrint("value is UserModel");

          resultMsg = value.msg ?? "";

          if (value.result == "SUCCESS") {
            userName = value.data.tu_name;
            // className = value.className;
            // classSeq = value.result.tu_seq;
            // className = value.result.tu_class_seq;
            userSeq = int.parse(value.data.tu_seq);
            userID = id;
            userPW = pw;

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

  void clear() {
    userName = "";
    userSeq = -1;
    userID = "";
    userPW = "";
  }

  void logout() {
    clear();
  }
}
