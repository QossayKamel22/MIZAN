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
    'auth_name': 'Name',
    'auth_email': 'Email',
    'auth_password': 'Password',
    'auth_confirm_password': 'Confirm Password',
    'auth_forgot_password': 'Forgot password?',
    'auth_no_account': "Don't have an account?",
    'auth_have_account': 'Already have an account?',
    'auth_login_failed': 'Login failed. Check your credentials and try again.',
    'auth_register_failed': 'Could not create account. Please try again.',
    'auth_name_required': 'Name is required',
    'auth_passwords_dont_match': "Passwords don't match",
    'auth_reset_password': 'Reset Password',
    'auth_reset_password_instructions':
        "Enter your email and we'll send you a link to reset your password.",
    'auth_reset_password_send': 'Send Reset Link',
    'auth_reset_password_sent':
        'If an account exists for this email, a reset link has been sent.',
    'auth_error_invalid_email': 'That email address looks invalid.',
    'auth_error_weak_password': 'Choose a stronger password (at least 8 characters).',
    'auth_error_email_in_use': 'An account already exists with this email.',
    'auth_error_user_not_found': 'No account found with these credentials.',
    'auth_error_wrong_password': 'Incorrect email or password.',
    'auth_error_user_disabled': 'This account has been disabled.',
    'auth_error_too_many_requests': 'Too many attempts. Please wait and try again.',
    'auth_error_network': 'Network error. Check your connection and try again.',
    'auth_error_not_configured':
        'Sign-in is not available yet — this build is not connected to a live Firebase project.',

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
    'auth_name': 'الاسم',
    'auth_email': 'البريد الإلكتروني',
    'auth_password': 'كلمة المرور',
    'auth_confirm_password': 'تأكيد كلمة المرور',
    'auth_forgot_password': 'نسيت كلمة المرور؟',
    'auth_no_account': 'ليس لديك حساب؟',
    'auth_have_account': 'لديك حساب بالفعل؟',
    'auth_login_failed': 'فشل تسجيل الدخول. تحقق من بياناتك وحاول مرة أخرى.',
    'auth_register_failed': 'تعذّر إنشاء الحساب. حاول مرة أخرى.',
    'auth_name_required': 'الاسم مطلوب',
    'auth_passwords_dont_match': 'كلمتا المرور غير متطابقتين',
    'auth_reset_password': 'إعادة تعيين كلمة المرور',
    'auth_reset_password_instructions':
        'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور.',
    'auth_reset_password_send': 'إرسال رابط إعادة التعيين',
    'auth_reset_password_sent':
        'إذا كان هناك حساب مرتبط بهذا البريد، فسيتم إرسال رابط إعادة التعيين إليه.',
    'auth_error_invalid_email': 'البريد الإلكتروني غير صالح.',
    'auth_error_weak_password': 'اختر كلمة مرور أقوى (8 أحرف على الأقل).',
    'auth_error_email_in_use': 'يوجد حساب مسجل بالفعل بهذا البريد الإلكتروني.',
    'auth_error_user_not_found': 'لا يوجد حساب بهذه البيانات.',
    'auth_error_wrong_password': 'البريد الإلكتروني أو كلمة المرور غير صحيحة.',
    'auth_error_user_disabled': 'تم تعطيل هذا الحساب.',
    'auth_error_too_many_requests': 'محاولات كثيرة جداً. الرجاء الانتظار والمحاولة مرة أخرى.',
    'auth_error_network': 'خطأ في الشبكة. تحقق من اتصالك وحاول مرة أخرى.',
    'auth_error_not_configured':
        'تسجيل الدخول غير متاح حالياً — هذا الإصدار غير متصل بمشروع Firebase حقيقي بعد.',

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
