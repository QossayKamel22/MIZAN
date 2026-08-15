import 'package:get/get.dart';

/// MIZAN translations via GetX's native translation system (no build_runner
/// codegen dependency — verifiable as plain Dart). Arabic strings are
/// written as natural Arabic copy, not machine-translated filler
/// (docs/NON_FUNCTIONAL_REQUIREMENTS.md NFR-L10N-1).
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': _en,
        'ar': _ar,
      };

  static const _en = {
    // Common
    'app_name': 'MIZAN',
    'action_save': 'Save',
    'action_cancel': 'Cancel',
    'action_edit': 'Edit',
    'action_delete': 'Delete',
    'action_retry': 'Retry',
    'action_see_all': 'See all',
    'state_loading': 'Loading...',
    'state_error_generic': 'Something went wrong. Please try again.',

    // Auth
    'auth_login': 'Log In',
    'auth_register': 'Create Account',
    'auth_email': 'Email',
    'auth_password': 'Password',
    'auth_forgot_password': 'Forgot password?',
    'auth_no_account': "Don't have an account?",
    'auth_have_account': 'Already have an account?',
    'auth_login_failed': 'Login failed. Check your credentials and try again.',
    'auth_register_failed': 'Could not create account. Please try again.',

    // Dashboard
    'dashboard_title': 'Dashboard',
    'dashboard_balance': 'Total Balance',
    'dashboard_income': 'Income',
    'dashboard_expenses': 'Expenses',
    'dashboard_upcoming_bills': 'Upcoming Bills',
    'dashboard_budgets': 'Budgets',
    'dashboard_goals': 'Goals',
    'dashboard_ai_insight': 'Ask MIZAN',
    'dashboard_empty': 'Add your first income or expense to see your overview here.',

    // Add Transaction
    'add_title': 'Add',
    'add_income': 'Income',
    'add_expense': 'Expense',
    'add_transfer': 'Transfer',
    'add_bill': 'Bill',
    'add_savings': 'Savings',
    'add_goal': 'Goal',
    'add_amount': 'Amount',
    'add_category': 'Category',
    'add_date': 'Date',
    'add_notes': 'Notes (optional)',

    // Budget
    'budget_title': 'Budget & Transfers',
    'budget_create': 'Create Budget',
    'budget_remaining': 'Remaining',
    'budget_spent': 'Spent',
    'budget_of': 'of',
    'budget_empty': 'No budgets yet. Create one to start tracking your spending.',
    'transfers_history': 'Transfer History',

    // Notifications
    'notifications_title': 'Notifications',
    'notifications_empty': "You're all caught up — no notifications yet.",
    'notifications_mark_all_read': 'Mark all as read',

    // AI Assistant
    'ai_title': 'MIZAN Assistant',
    'ai_placeholder': 'Ask about your finances...',
    'ai_disclaimer':
        'MIZAN provides informational insights, not licensed financial advice.',

    // Settings
    'settings_title': 'Settings',
    'settings_profile': 'Profile',
    'settings_appearance': 'Appearance',
    'settings_language': 'Language',
    'settings_security': 'Security',
    'settings_notifications': 'Notification Preferences',
    'settings_theme_system': 'System Default',
    'settings_theme_light': 'Light',
    'settings_theme_dark': 'Dark',
    'settings_logout': 'Log Out',
  };

  static const _ar = {
    // Common
    'app_name': 'ميزان',
    'action_save': 'حفظ',
    'action_cancel': 'إلغاء',
    'action_edit': 'تعديل',
    'action_delete': 'حذف',
    'action_retry': 'إعادة المحاولة',
    'action_see_all': 'عرض الكل',
    'state_loading': 'جارٍ التحميل...',
    'state_error_generic': 'حدث خطأ ما. حاول مرة أخرى.',

    // Auth
    'auth_login': 'تسجيل الدخول',
    'auth_register': 'إنشاء حساب',
    'auth_email': 'البريد الإلكتروني',
    'auth_password': 'كلمة المرور',
    'auth_forgot_password': 'نسيت كلمة المرور؟',
    'auth_no_account': 'ليس لديك حساب؟',
    'auth_have_account': 'لديك حساب بالفعل؟',
    'auth_login_failed': 'فشل تسجيل الدخول. تحقق من بياناتك وحاول مرة أخرى.',
    'auth_register_failed': 'تعذّر إنشاء الحساب. حاول مرة أخرى.',

    // Dashboard
    'dashboard_title': 'الرئيسية',
    'dashboard_balance': 'الرصيد الإجمالي',
    'dashboard_income': 'الدخل',
    'dashboard_expenses': 'المصروفات',
    'dashboard_upcoming_bills': 'الفواتير القادمة',
    'dashboard_budgets': 'الميزانيات',
    'dashboard_goals': 'الأهداف',
    'dashboard_ai_insight': 'اسأل ميزان',
    'dashboard_empty': 'أضف أول دخل أو مصروف لترى نظرتك المالية العامة هنا.',

    // Add Transaction
    'add_title': 'إضافة',
    'add_income': 'دخل',
    'add_expense': 'مصروف',
    'add_transfer': 'تحويل',
    'add_bill': 'فاتورة',
    'add_savings': 'ادخار',
    'add_goal': 'هدف',
    'add_amount': 'المبلغ',
    'add_category': 'الفئة',
    'add_date': 'التاريخ',
    'add_notes': 'ملاحظات (اختياري)',

    // Budget
    'budget_title': 'الميزانية والتحويلات',
    'budget_create': 'إنشاء ميزانية',
    'budget_remaining': 'المتبقي',
    'budget_spent': 'المُنفق',
    'budget_of': 'من',
    'budget_empty': 'لا توجد ميزانيات بعد. أنشئ واحدة لبدء تتبع إنفاقك.',
    'transfers_history': 'سجل التحويلات',

    // Notifications
    'notifications_title': 'الإشعارات',
    'notifications_empty': 'لا توجد إشعارات جديدة حالياً.',
    'notifications_mark_all_read': 'تعليم الكل كمقروء',

    // AI Assistant
    'ai_title': 'مساعد ميزان',
    'ai_placeholder': 'اسأل عن أموالك...',
    'ai_disclaimer': 'ميزان يقدّم رؤى معلوماتية، وليست استشارة مالية مرخّصة.',

    // Settings
    'settings_title': 'الإعدادات',
    'settings_profile': 'الملف الشخصي',
    'settings_appearance': 'المظهر',
    'settings_language': 'اللغة',
    'settings_security': 'الأمان',
    'settings_notifications': 'تفضيلات الإشعارات',
    'settings_theme_system': 'حسب النظام',
    'settings_theme_light': 'فاتح',
    'settings_theme_dark': 'داكن',
    'settings_logout': 'تسجيل الخروج',
  };
}
