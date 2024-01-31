import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/ui/product/product_history_model.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_repository.dart';

class ProductOutController extends GetxController {
  static ProductOutController get to => Get.find();

  final ProductOutRepository repository;
  ProductOutController({required this.repository});

  RxBool isLoading = false.obs;

  List<ProductHistoryModel> _list = [];

  clearData() {
    isLoading.value = true;
    _list.clear();

    isLoading.value = false;
    return true;
  }

  Future<bool> refreshData({String searchData = "", int filterIndex = -1}) async {
    isLoading.value = true;
    bool isSuccess = false;
    _list.clear();

    String filterYear = DateTime.now().year.toString();
    String filterMonth = DateTime.now().month.toString();

    String type = Utils.getSearchType(filterIndex: filterIndex);

    await repository.reqReadAll(year: filterYear, month: filterMonth, type: type, txt: searchData).then((value) async {
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

  Future<bool> searchBarcode({required String searchData}) async {
    isLoading.value = true;
    bool isSuccess = false;

    String filterYear = DateTime.now().year.toString();
    String filterMonth = DateTime.now().month.toString();

    await repository.reqSearchBarcode(year: filterYear, month: filterMonth, txt: searchData).then((value) async {
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

    String filterYear = DateTime.now().year.toString();
    String filterMonth = DateTime.now().month.toString();

    String type = Utils.getSearchType(filterIndex: filterIndex);

    await repository.reqReadAll(year: filterYear, month: filterMonth, type: type, txt: searchData).then((value) async {
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
