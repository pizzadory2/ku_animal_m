import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/ui/inventory/inven_repository.dart';
import 'package:ku_animal_m/src/ui/product/inven_model.dart';

class InvenController extends GetxController {
  static InvenController get to => Get.find();

  final InvenRepository repository;
  InvenController({required this.repository});

  RxBool isLoading = false.obs;

  List<InvenModel> _list = [];

  clearData() {
    isLoading.value = true;
    _list.clear();

    isLoading.value = false;
    return true;
  }

  Future<bool> refreshData() async {
    isLoading.value = true;
    bool isSuccess = false;
    _list.clear();

    await repository.reqReadAll(year: "2024", month: "1").then((value) async {
      isLoading.value = false;

      if (value != null) {
        _list = value;
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    });

    isLoading.value = false;
    return isSuccess;
  }

  Future<bool> searchBarcode({required String searchData}) async {
    isLoading.value = true;
    bool isSuccess = false;

    await repository.reqSearchBarcode(year: "2024", month: "1", txt: searchData).then((value) async {
      isLoading.value = false;

      if (value != null) {
        _list = value;
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    });

    isLoading.value = false;
    return isSuccess;
  }

  Future<bool> searchData({required String searchData, required int filterIndex}) async {
    isLoading.value = true;
    bool isSuccess = false;
    _list.clear();

    String type = Utils.getSearchTypeInven(filterIndex: filterIndex);

    await repository.reqReadAll(year: "2024", month: "1", type: type, txt: searchData).then((value) async {
      isLoading.value = false;

      if (value != null) {
        _list = value;
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    });

    debugPrint("[animal] 검색 데이터는: ${_list.length}");

    isLoading.value = false;
    return isSuccess;
  }

  getCount() {
    return _list.length;
  }

  getItem(int index) {
    return _list[index];
  }
}
