from __future__ import annotations

from ai.agents.state import AgentState

_DISCLAIMER = {
    "en": "MIZAN provides informational insights, not licensed financial advice.",
    "ar": "ميزان يقدّم رؤى معلوماتية، وليست استشارة مالية مرخّصة.",
}


def run(state: AgentState) -> AgentState:
    """Composes the final grounded answer strictly from `tool_results`
    (docs/AI_AGENT_ARCHITECTURE.md §3, §7 — never states a figure that
    didn't come from a tool call).

    This deterministic-template synthesis is the fallback path used when no
    live LLM is configured (docs/AI_AGENT_ARCHITECTURE.md §6). When
    `ANTHROPIC_API_KEY`/`OPENAI_API_KEY` is set, production wiring should
    replace this function's body with an LLM call whose prompt is
    constrained to only reference `state['tool_results']` (see
    ai/prompts/synthesis_system_prompt.md) — the graph shape and every
    other node stay unchanged (NFR-SCALE-2)."""
    language = state.get("language", "en")
    intent = state.get("intent", "general_qa")
    tool_results = state.get("tool_results", [])

    answer = _template_answer(intent, tool_results, language)
    answer = f"{answer}\n\n{_DISCLAIMER.get(language, _DISCLAIMER['en'])}" if intent == "recommendation" else answer

    return {**state, "answer": answer}


def _template_answer(intent: str, tool_results: list[dict], language: str) -> str:
    by_tool = {r["tool"]: r["data"] for r in tool_results}

    if intent == "spending_analysis" and "get_spending_by_category" in by_tool:
        breakdown = by_tool["get_spending_by_category"]
        if not breakdown:
            return "You haven't logged any expenses yet this period."
        top_category, top_amount = max(breakdown.items(), key=lambda kv: kv[1])
        return f"This period, you spent the most on {top_category}: AED {top_amount:.0f}."

    if intent == "bill_assistant" and "get_upcoming_bills" in by_tool:
        bills = by_tool["get_upcoming_bills"]
        if not bills:
            return "You have no bills due in the next 14 days."
        total = sum(b["amount"] for b in bills)
        names = ", ".join(b["payee"] for b in bills)
        return f"You have {len(bills)} bill(s) due in the next 14 days totaling AED {total:.0f}: {names}."

    if intent == "recommendation" and "get_budget_status" in by_tool:
        budgets = by_tool["get_budget_status"]
        if not budgets:
            return "You don't have an active budget yet, so I can't check that against a limit."
        b = budgets[0]
        remaining = b["limit"] - b["spent"]
        return (
            f"Your {b['category']} budget has AED {remaining:.0f} remaining "
            f"this period ({b['percent_used'] * 100:.0f}% used)."
        )

    if "get_income_vs_expense" in by_tool:
        data = by_tool["get_income_vs_expense"]
        return (
            f"So far this period: income AED {data['income']:.0f}, "
            f"expenses AED {data['expense']:.0f}."
        )

    return "I can help with spending patterns, upcoming bills, and budget status — try asking a specific question about those."
