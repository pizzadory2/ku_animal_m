import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/ui/product/inven_model.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';
import 'package:ku_animal_m/src/ui/search/search_repository.dart';

class SearchHomeController extends GetxController {
  static SearchHomeController get to => Get.find();

  final SearchRepository repository;
  SearchHomeController({required this.repository});

  RxBool isLoading = false.obs;

  List<ProductModel> _list = [];
  List<InvenModel> _listInven = [];

  clearData() {
    isLoading.value = true;
    _list.clear();

    isLoading.value = false;
    return true;
  }

  Future<bool> searchBarcode({required String searchData}) async {
    isLoading.value = true;
    bool isSuccess = false;
    _list.clear();

    await repository.reqSearchBarcode(txt: searchData).then((value) async {
      isLoading.value = false;

      if (value != null) {
        _list.add(value);
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    });

    isLoading.value = false;
    return isSuccess;
  }

  Future<bool> searchData({String type = "", String searchData = ""}) async {
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

  Future<bool> searchSafeMidal() async {
    isLoading.value = true;
    bool isSuccess = false;
    _listInven.clear();

    await repository.reqReadAllSafeMidal().then((value) async {
      isLoading.value = false;

      if (value != null) {
        _listInven = value;
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    });

    debugPrint("[animal] 메인 검색 데이터는: ${_list.length}");

    isLoading.value = false;
    return isSuccess;
  }

  List<InvenModel> getSafeList() {
    List<InvenModel> safeList = [];

    for (var item in _listInven) {
      int safeCount = Utils.atoi(item.mi_safety_stock);
      int baseCount = Utils.atoi(item.mst_base_stock);

      if (safeCount > baseCount) {
        safeList.add(item);
      }
    }

    return safeList;
  }
}
