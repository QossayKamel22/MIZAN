/// Route name constants — see docs/NAVIGATION_STRUCTURE.md §2 for the full
/// route table. Screens navigate exclusively via `Get.toNamed(AppRoutes.x)`,
/// never raw `Navigator.push`.
abstract class AppRoutes {
  static const splash = '/splash';
  static const auth = '/auth';
  static const login = '/auth/login';
  static const register = '/auth/register';

  static const dashboard = '/dashboard';

  static const budget = '/budget';
  static const budgetCreate = '/budget/create';

  static const add = '/add';
  static const addExpense = '/add/expense';
  static const addIncome = '/add/income';

  static const notifications = '/notifications';
  static const aiAssistant = '/ai-assistant';

  static const settings = '/settings';
  static const settingsAppearance = '/settings/appearance';
  static const settingsLanguage = '/settings/language';
}
