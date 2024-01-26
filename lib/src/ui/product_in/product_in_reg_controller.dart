import 'package:get/get.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_reg_repository.dart';

class ProductInRegController extends GetxController {
  static ProductInRegController get to => Get.find();

  final ProductInRegRepository repository;
  ProductInRegController({required this.repository});

  RxBool isLoading = false.obs;

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
}
