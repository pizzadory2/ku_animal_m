import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

    clear();

    debugPrint("[animal] 로그인로그인로그인777777777777777");

    await repository.reqLogin(id: id, pw: pw).then((value) {
      isLoading.value = false;

      if (value != null) {
        if (value.resultMsg == "SUCCESS") {
          userName = value.result.tu_name;
          // className = value.className;
          // classSeq = value.result.tu_seq;
          // className = value.result.tu_class_seq;
          userSeq = int.parse(value.result.tu_seq);
          userID = id;
          userPW = pw;

          isSuccess = true;
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }
    });

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
