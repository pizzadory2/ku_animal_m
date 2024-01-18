import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/preference.dart';
import 'package:ku_animal_m/src/ui/home/home_repository.dart';
import 'package:ku_animal_m/src/ui/login/user_model.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final HomeRepository repository;
  HomeController({required this.repository});

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
    Preference().setString("userId", "");
    Preference().setString("userPw", "");

    clear();
  }

  Future<bool> refreshData() async {
    isLoading.value = true;
    bool isSuccess = false;

    // await repository.loadAll(userSeq: userSeq).then((value) async {
    //   isLoading.value = false;

    //   if (value != null) {
    //     // 전체 지우기
    //     int dataCount = clientModel.length;
    //     for (int i = dataCount - 1; i >= 0; i--) {
    //       debugPrint("가나다 --- 1");
    //       clientModel.deleteAt(i);
    //       debugPrint("가나다 --- 2");
    //     }
    //     //

    //     List<ContactDetailModel> list = value;

    //     int id = generateId();
    //     debugPrint("가나다 --- 4");

    //     DateTime today = DateTime.now();

    //     for (int i = 0; i < list.length; i++) {
    //       DateTime createDate =
    //           list[i].createDate != null ? DateTime.parse(list[i].createDate!) : DateTime.parse("19000101");
    //       ClientModel data = ClientModel(
    //         id: id,
    //         idServer: list[i].id ?? -1,
    //         name: list[i].name ?? "",
    //         phone: list[i].phone ?? "",
    //         company: list[i].company ?? "",
    //         jobPosition: list[i].job ?? "",
    //         createDate: today,
    //         image: null,
    //         isUpload: true,
    //         etc: list[i].etc ?? "",
    //         imageUrl: list[i].imageUrl ?? "",
    //       );
    //       clientModel.put(id, data);

    //       id++;
    //     }
    //     isSuccess = true;

    //     update();
    //   } else {
    //     isSuccess = false;
    //   }
    // });

    return isSuccess;
  }
}
