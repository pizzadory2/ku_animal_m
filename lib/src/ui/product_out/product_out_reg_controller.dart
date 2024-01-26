import 'package:get/get.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_reg_repository.dart';

class ProductOutRegController extends GetxController {
  static ProductOutRegController get to => Get.find();

  final ProductOutRegRepository repository;
  ProductOutRegController({required this.repository});

  RxBool isLoading = false.obs;

  final List<ProductModel> _list = [];

  clearData() {
    isLoading.value = true;
    _list.clear();

    isLoading.value = false;
    return true;
  }

  addItem(ProductModel item) {
    _list.add(item);
  }

  getCount() {
    return _list.length;
  }

  getItem(int index) {
    return _list[index];
  }
}
