import 'package:get/get.dart';
import 'package:ku_animal_m/src/controller/app_controller.dart';
import 'package:ku_animal_m/src/ui/login/user_controller.dart';
import 'package:ku_animal_m/src/ui/login/user_repository.dart';

class InitBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put<InitController>(InitController());
    Get.put(AppController(), permanent: true);
    Get.put(UserController(repository: UserRepository()), permanent: true);
  }
}
