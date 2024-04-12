import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxInt notificationCount = 0.obs;

  void increment() {
    notificationCount.value++;
  }
}
