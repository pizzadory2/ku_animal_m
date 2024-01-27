import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/ui/home/home_model.dart';
import 'package:ku_animal_m/src/ui/home/home_repository.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  HomeModel _homeModel = HomeModel();
  HomeModel get homeModel => _homeModel;

  final HomeRepository repository;
  HomeController({required this.repository});

  RxBool isLoading = false.obs;

  Future<bool> refreshData() async {
    isLoading.value = true;
    bool isSuccess = false;
    String resultMsg = "네트워크 상태를 확인해주세요.";

    _homeModel.clear();

    await repository.reqReadAll().then((value) async {
      isLoading.value = false;

      if (value != null) {
        if (value is HomeModel) {
          resultMsg = value.msg ?? "";

          if (value.result == "SUCCESS") {
            isSuccess = true;
          } else {
            isSuccess = false;
          }
        } else {
          isSuccess = false;
        }

        _homeModel = value;
      } else {
        isSuccess = false;
      }
    });

    isLoading.value = false;
    if (isSuccess == false) {
      Utils.showToast(resultMsg, isCenter: true);
    }

    return isSuccess;
  }
}
