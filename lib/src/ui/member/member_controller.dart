import 'package:get/get.dart';
import 'package:ku_animal_m/src/ui/member/member_model.dart';
import 'package:ku_animal_m/src/ui/member/member_repository.dart';
import 'package:ku_animal_m/src/ui/product/product_model.dart';

class MemberController extends GetxController {
  static MemberController get to => Get.find();

  final MemberRepository repository;
  MemberController({required this.repository});

  RxBool isLoading = false.obs;

  final List<MemberModel> _list = [];

  clearData() {
    isLoading.value = true;
    _list.clear();

    isLoading.value = false;
    return true;
  }

  addProduct(MemberModel item, int count) {
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
