import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ku_animal_m/src/common/utils.dart';
import 'package:ku_animal_m/src/ui/inventory/inven_repository.dart';
import 'package:ku_animal_m/src/ui/inventory/order_model.dart';
import 'package:ku_animal_m/src/ui/product/inven_model.dart';

class InvenController extends GetxController {
  static InvenController get to => Get.find();

  final InvenRepository repository;
  InvenController({required this.repository});

  RxBool isLoading = false.obs;

  List<InvenModel> _list = [];
  List<OrderModel> _orderList = [];
  RxInt orderCount = 0.obs;

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

    String filterYear = DateTime.now().year.toString();
    String filterMonth = DateTime.now().month.toString();

    await repository.reqReadAll(year: filterYear, month: filterMonth).then((value) async {
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

  Future<bool> searchData(
      {required String searchData, required int filterIndex, required String year, required String month}) async {
    isLoading.value = true;
    bool isSuccess = false;
    _list.clear();

    String type = Utils.getSearchType(filterIndex: filterIndex);

    await repository.reqReadAll(year: year, month: month, type: type, txt: searchData).then((value) async {
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

  addCart({required InvenModel item, required int count}) {
    debugPrint("[animal] 장바구니 추가");
  }

  Future<bool> orderStock({required String title, required String reason}) async {
    isLoading.value = true;
    bool isSuccess = false;
    await repository.reqStockOrder(list: _orderList, msg: title, reason: reason).then((value) async {
      isLoading.value = false;

      if (value != null) {
        if (value.result == "SUCCESS") {
          isSuccess = true;
          _orderList.clear();
        } else {
          isSuccess = false;
        }
      } else {
        isSuccess = false;
      }
    });

    debugPrint("[animal] 요청 데이터는: ${_orderList.length}");

    isLoading.value = false;
    return isSuccess;
  }

  getCount() {
    return _list.length;
  }

  getItem(int index) {
    return _list[index];
  }

  void addOrderList({required OrderModel data}) {
    _orderList.add(data);
    changeOrderCount();
  }

  getOrderCount() {
    return _orderList.length;
  }

  OrderModel getOrder(int index) {
    return _orderList[index];
  }

  void removeOrder(int index) {
    _orderList.removeAt(index);
    changeOrderCount();
  }

  void clearOrderList() {
    _orderList.clear();
    changeOrderCount();
  }

  void changeOrderCount() {
    orderCount.value = _orderList.length;
  }
}
