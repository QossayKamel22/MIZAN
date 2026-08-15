from __future__ import annotations

from ai.agents.state import AgentState

# Deterministic keyword-based routing used as the fallback/default path and
# as the ground truth for the eval set (ai/tests/eval_questions.json). When
# a live LLM is configured, this can be swapped for LLM-based intent
# classification without changing node/tool contracts
# (docs/AI_AGENT_ARCHITECTURE.md §3, §5 — modular by design).
_INTENT_KEYWORDS = {
    "spending_analysis": ["spend", "spent", "category", "أنفقت", "صرف"],
    "recommendation": ["afford", "should i", "recommend", "أقدر", "أنصح"],
    "bill_assistant": ["bill", "due", "فاتورة", "فواتير"],
    "general_qa": [],  # fallback
}


def classify_intent(state: AgentState) -> AgentState:
    question = state["question"].lower()
    for intent, keywords in _INTENT_KEYWORDS.items():
        if any(keyword in question for keyword in keywords):
            return {**state, "intent": intent}
    return {**state, "intent": "general_qa"}
