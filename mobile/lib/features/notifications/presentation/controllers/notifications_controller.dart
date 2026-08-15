import 'package:get/get.dart';
import '../../../../core/local_store/finance_store.dart';

class NotificationsController extends GetxController {
  final FinanceStore _store = Get.find<FinanceStore>();

  FinanceStore get store => _store;

  void markRead(String id) => _store.markNotificationRead(id);
  void markAllRead() => _store.markAllNotificationsRead();
}
