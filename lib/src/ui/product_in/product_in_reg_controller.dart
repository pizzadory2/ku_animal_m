import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';
import 'package:ku_animal_m/src/ui/product/product_reg_model.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_reg_repository.dart';

class ProductInRegController extends GetxController {
  static ProductInRegController get to => Get.find();

  final ProductInRegRepository repository;
  ProductInRegController({required this.repository});

  RxBool isLoading = false.obs;

  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;

  final List<ProductModel> _list = [];

  clearData() {
    isLoading.value = true;
    _list.clear();

    isLoading.value = false;
    return true;
  }

  addProduct(ProductModel item, int count) {
    item.inout_count = count;
    _list.add(item);
  }

  getCount() {
    return _list.length;
  }

  getItem(int index) {
    return _list[index];
  }

  void removeProduct(ProductModel data) {
    _list.remove(data);
  }

  Future<bool> regProduct({required String userSeq}) async {
    isLoading.value = true;
    bool isSuccess = false;
    String resultMsg = "네트워크 상태를 확인해주세요.";

    await repository
        .reqRegProduct(list: _list, year: _currentYear.toString(), month: _currentMonth.toString(), userSeq: userSeq)
        .then((value) {
      isLoading.value = false;
      if (value != null) {
        // Get.back(result: true);

        if (value is ProductRegModel) {
          resultMsg = value.msg ?? "";

          if (value.result == "SUCCESS") {
            isSuccess = true;
          } else {
            isSuccess = false;
          }
        } else {
          isSuccess = false;
        }
      } else {
        // null 이다
        isSuccess = false;
      }
    });

    if (isSuccess == false) {
      // Utils.showToast(resultMsg);
      Utils.showToast(resultMsg, isCenter: true);
      // Get.snackbar("Registration failed".tr, resultMsg);
    }

    return isSuccess;
  }
}
