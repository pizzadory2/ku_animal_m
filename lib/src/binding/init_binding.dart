import 'package:get/get.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/ui/home/home_controller.dart';
import 'package:ku_animal_m/src/ui/home/home_repository.dart';
import 'package:ku_animal_m/src/ui/inventory/inven_controller.dart';
import 'package:ku_animal_m/src/ui/inventory/inven_repository.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';
import 'package:ku_animal_m/src/ui/login/user_repository.dart';
import 'package:ku_animal_m/src/ui/member/member_controller.dart';
import 'package:ku_animal_m/src/ui/member/member_repository.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_controller.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_reg_controller.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_reg_repository.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_repository.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_controller.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_reg_controller.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_reg_repository.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_repository.dart';
import 'package:ku_animal_m/src/ui/search/search_home_controller.dart';
import 'package:ku_animal_m/src/ui/search/search_repository.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put<InitController>(InitController());
    Get.put(AppController(), permanent: true);
    Get.put(HomeController(repository: HomeRepository()), permanent: true);
    Get.put(SearchHomeController(repository: SearchRepository()), permanent: true);
    Get.put(InvenController(repository: InvenRepository()), permanent: true);
    Get.put(ProductInController(repository: ProductInRepository()), permanent: true);
    Get.put(ProductInRegController(repository: ProductInRegRepository()), permanent: true);
    Get.put(ProductOutController(repository: ProductOutRepository()), permanent: true);
    Get.put(ProductOutRegController(repository: ProductOutRegRepository()), permanent: true);
    Get.put(UserController(repository: UserRepository()), permanent: true);
    Get.put(MemberController(repository: MemberRepository()), permanent: true);
  }
}
