import 'package:get/get.dart';
import '../controllers/budget_controller.dart';

class BudgetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BudgetController>(() => BudgetController());
  }
}
