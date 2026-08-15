import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/app_colors.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/budgets/presentation/screens/budget_screen.dart';
import '../features/notifications/presentation/screens/notifications_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/transactions/presentation/screens/add_type_selector_sheet.dart';
import '../core/local_store/finance_store.dart';

/// Bottom-nav shell hosting the 5 primary destinations
/// (docs/NAVIGATION_STRUCTURE.md §1). "Add" is a modal action, not a
/// persistent tab.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final _screens = const [
    DashboardScreen(),
    BudgetScreen(),
    SizedBox.shrink(), // Add is modal, placeholder index
    NotificationsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final unreadCount =
        Get.find<FinanceStore>().notifications.where((n) => !n.isRead).length;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) {
          if (i == 2) {
            AddTypeSelectorSheet.show(context);
            return;
          }
          setState(() => _index = i);
        },
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.dashboard_outlined),
              activeIcon: const Icon(Icons.dashboard),
              label: 'dashboard_title'.tr),
          BottomNavigationBarItem(
              icon: const Icon(Icons.pie_chart_outline),
              activeIcon: const Icon(Icons.pie_chart),
              label: 'budget_title'.tr),
          BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: colors.primary, shape: BoxShape.circle),
                child: Icon(Icons.add, color: colors.onPrimary),
              ),
              label: 'add_title'.tr),
          BottomNavigationBarItem(
              icon: Obx(() => _NotifIcon(count: unreadCount)),
              label: 'notifications_title'.tr),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings_outlined),
              activeIcon: const Icon(Icons.settings),
              label: 'settings_title'.tr),
        ],
      ),
    );
  }
}

class _NotifIcon extends StatelessWidget {
  const _NotifIcon({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.notifications_outlined),
        if (count > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: context.colors.danger, shape: BoxShape.circle),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              child: Text('$count',
                  style: const TextStyle(color: Colors.white, fontSize: 9),
                  textAlign: TextAlign.center),
            ),
          ),
      ],
    );
  }
}
