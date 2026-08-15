import 'package:get/get.dart';
import '../controllers/ai_assistant_controller.dart';

class AiAssistantBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiAssistantController>(() => AiAssistantController());
  }
}
