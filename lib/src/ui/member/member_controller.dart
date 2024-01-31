import 'package:get/get.dart';
import 'package:ku_animal_m/src/ui/member/member_model.dart';
import 'package:ku_animal_m/src/ui/member/member_repository.dart';

class MemberController extends GetxController {
  static MemberController get to => Get.find();

  final MemberRepository repository;
  MemberController({required this.repository});

  RxBool isLoading = false.obs;

  List<MemberModel> _list = [];

  clearData() {
    isLoading.value = true;
    _list.clear();

    isLoading.value = false;
    return true;
  }

  getCount() {
    return _list.length;
  }

  getItem(int index) {
    return _list[index];
  }

  Future<bool> refreshData() async {
    isLoading.value = true;
    bool isSuccess = false;
    _list.clear();

    await repository.reqReadAll().then((value) async {
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
}
