import 'package:get/get.dart';
import '../../../../core/local_store/finance_store.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../domain/entities/chat_message.dart';

/// Client-side stand-in for the backend `/ai/ask` endpoint
/// (docs/API_SPECIFICATION.md §9) and the LangGraph agent graph
/// (docs/AI_AGENT_ARCHITECTURE.md).
///
/// This is a deliberately simple, deterministic, RULE-BASED router over the
/// same [FinanceStore] "tools" the real agent would call — grounded in
/// real local data, never fabricated numbers. It exists so the AI Assistant
/// screen and UX are real and testable today.
///
/// It is explicitly NOT the LangGraph/LLM-backed assistant described in
/// docs/AI_AGENT_ARCHITECTURE.md — that requires a live LLM provider key
/// and the backend's `/ai/ask` endpoint (see ai/agents/graph.py in this
/// repo for the real graph implementation, and
/// docs/FINAL_TECHNICAL_REPORT.md for pending-integration status). Per the
/// project's "no fake completion" rule, this limitation is documented, not
/// hidden.
class AiAssistantController extends GetxController {
  final FinanceStore _store = Get.find<FinanceStore>();
  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isThinking = false.obs;

  Future<void> ask(String question) async {
    if (question.trim().isEmpty) return;
    messages.add(ChatMessage(
        role: ChatRole.user, text: question, createdAt: DateTime.now()));
    isThinking.value = true;

    await Future.delayed(const Duration(milliseconds: 500));
    final answer = _routeAndAnswer(question.toLowerCase());

    messages.add(ChatMessage(
        role: ChatRole.assistant, text: answer, createdAt: DateTime.now()));
    isThinking.value = false;
  }

  String _routeAndAnswer(String question) {
    // --- Tool: get_spending_by_category ---
    if (question.contains('spend') && question.contains('most') ||
        question.contains('أكثر') && question.contains('صرف')) {
      final expenses = _store.transactions
          .where((t) => t.type == TransactionType.expense);
      if (expenses.isEmpty) {
        return "You haven't logged any expenses yet, so I can't tell you where you spent the most.";
      }
      final byCategory = <String, double>{};
      for (final t in expenses) {
        final key = t.categoryName ?? 'Uncategorized';
        byCategory[key] = (byCategory[key] ?? 0) + t.amount;
      }
      final top = byCategory.entries.reduce((a, b) => a.value > b.value ? a : b);
      return 'This month, you spent the most on ${top.key}: AED ${top.value.toStringAsFixed(0)}.';
    }

    // --- Tool: get_upcoming_bills ---
    if (question.contains('bill') || question.contains('فاتورة') || question.contains('فواتير')) {
      final upcoming = _store.bills.where(
          (b) => b.dueDate.isBefore(DateTime.now().add(const Duration(days: 14))));
      if (upcoming.isEmpty) return "You have no bills due in the next 14 days.";
      final total = upcoming.fold(0.0, (s, b) => s + b.amount);
      return 'You have ${upcoming.length} bill(s) due in the next 14 days totaling AED ${total.toStringAsFixed(0)}: '
          '${upcoming.map((b) => b.payeeName).join(', ')}.';
    }

    // --- Tool: get_budget_status + affordability check ---
    if (question.contains('afford') || question.contains('أقدر') || question.contains('استطيع')) {
      if (_store.budgets.isEmpty) {
        return "You don't have an active budget yet, so I can't check affordability against a limit — "
            'but your current balance is AED ${_store.totalBalance.toStringAsFixed(0)}.';
      }
      final budget = _store.budgets.first;
      return 'Your ${budget.categoryName ?? 'overall'} budget has AED ${budget.remainingAmount.toStringAsFixed(0)} remaining '
          'this period. Consider that before a new purchase. (Informational only — not financial advice.)';
    }

    // --- Tool: get_income_vs_expense ---
    if (question.contains('increase') || question.contains('لماذا') || question.contains('زاد')) {
      final start = DateTime(DateTime.now().year, DateTime.now().month, 1);
      final expenses = _store.totalForType(TransactionType.expense, since: start);
      return 'Your expenses so far this month total AED ${expenses.toStringAsFixed(0)}. '
          'I need at least one prior month of data to compare a trend — keep logging and I can show the delta.';
    }

    return "I can help with spending patterns, upcoming bills, budget status, and affordability questions. "
        'Try asking, for example: "Where did I spend the most this month?"';
  }
}
