import 'package:ku_animal_m/src/ui/home/home_controller.dart';
import 'package:ku_animal_m/src/ui/inventory/inven_controller.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_controller.dart';
import 'package:ku_animal_m/src/ui/product_in/product_in_reg_controller.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_controller.dart';
import 'package:ku_animal_m/src/ui/product_out/product_out_reg_controller.dart';
import 'package:ku_animal_m/src/ui/workmanage/work_manager_controller.dart';

import 'enums.dart';

class Controllers {
  static getController({required PageType type}) {
    return switch (type) {
      PageType.Home => HomeController.to,
      PageType.WorkManage => WorkManagerController.to,
      PageType.ProductIn => ProductInController.to,
      PageType.ProductOut => ProductOutController.to,
      PageType.ProductInven => InvenController.to,
      PageType.ProductRegIn => ProductInRegController.to,
      PageType.ProductRegOut => ProductOutRegController.to,
      PageType.Setting => HomeController.to
    };
  }
}
