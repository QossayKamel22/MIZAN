import 'package:get/get.dart';
import 'app_routes.dart';
import '../main_shell.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/bindings/auth_binding.dart';
import '../../features/dashboard/presentation/bindings/dashboard_binding.dart';
import '../../features/budgets/presentation/screens/budget_create_screen.dart';
import '../../features/budgets/presentation/bindings/budget_binding.dart';
import '../../features/notifications/presentation/bindings/notifications_binding.dart';
import '../../features/ai_assistant/presentation/screens/ai_assistant_screen.dart';
import '../../features/ai_assistant/presentation/bindings/ai_assistant_binding.dart';
import '../../features/transactions/presentation/bindings/add_transaction_binding.dart';
import '../../features/settings/presentation/screens/appearance_screen.dart';
import '../../features/settings/presentation/screens/language_screen.dart';
import 'auth_middleware.dart';

/// Route table implementing docs/NAVIGATION_STRUCTURE.md §2.
class AppPages {
  AppPages._();

  static final pages = [
    GetPage(name: AppRoutes.auth, page: () => const LoginScreen(), binding: AuthBinding()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen(), binding: AuthBinding()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen(), binding: AuthBinding()),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const MainShell(),
      bindings: [DashboardBinding(), BudgetBinding(), NotificationsBinding(), AddTransactionBinding()],
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.budgetCreate,
      page: () => const BudgetCreateScreen(),
      binding: BudgetBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.aiAssistant,
      page: () => const AiAssistantScreen(),
      binding: AiAssistantBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settingsAppearance,
      page: () => const AppearanceScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settingsLanguage,
      page: () => const LanguageScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
