import 'package:get/get.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/ui/home/home_controller.dart';
import 'package:ku_animal_m/src/ui/home/home_repository.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';
import 'package:ku_animal_m/src/ui/login/user_repository.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put<InitController>(InitController());
    Get.put(AppController(), permanent: true);
    Get.put(HomeController(repository: HomeRepository()), permanent: true);
    // Get.put(InvenController(repository: InvenRepository()), permanent: true);
    // Get.put(ProductInController(repository: ProductInRepository()), permanent: true);
    // Get.put(ProductOutController(repository: ProductOutRepository()), permanent: true);
    Get.put(UserController(repository: UserRepository()), permanent: true);
  }
}
