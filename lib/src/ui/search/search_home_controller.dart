import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';
import 'package:ku_animal_m/src/ui/search/search_repository.dart';

class SearchHomeController extends GetxController {
  static SearchHomeController get to => Get.find();

  final SearchRepository repository;
  SearchHomeController({required this.repository});

  RxBool isLoading = false.obs;

  List<ProductModel> _list = [];

  clearData() {
    isLoading.value = true;
    _list.clear();

    isLoading.value = false;
    return true;
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

  Future<bool> searchData({String type = "mi_name", required String searchData}) async {
    isLoading.value = true;
    bool isSuccess = false;
    _list.clear();

    await repository.reqReadAll(condition: type, searchData: searchData).then((value) async {
      isLoading.value = false;

      if (value != null) {
        _list = value;
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    });

    debugPrint("[animal] 메인 검색 데이터는: ${_list.length}");

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
