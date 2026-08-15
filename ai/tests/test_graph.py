import json
from pathlib import Path

from ai.agents.graph import run_agent

_EVAL_SET = json.loads((Path(__file__).parent / "eval_questions.json").read_text())


def test_run_agent_calls_expected_tool_and_returns_grounded_answer():
    for case in _EVAL_SET:
        result = run_agent(user_id="test-user", question=case["question"], language="en")
        assert case["expected_tool"] in result["tools_used"], case["question"]
        assert result["answer"]  # non-empty, grounded answer produced
        assert "AED" in result["answer"] or "budget" in result["answer"].lower()


def test_run_agent_never_fabricates_when_no_data():
    from ai.tools.data_provider import FinanceDataProvider

    class EmptyProvider(FinanceDataProvider):
        def get_spending_by_category(self, user_id, period_start, period_end):
            return {}

        def get_income_vs_expense(self, user_id, period_start, period_end):
            return {"income": 0.0, "expense": 0.0}

        def get_budget_status(self, user_id):
            return []

        def get_upcoming_bills(self, user_id, horizon_days):
            return []

        def get_goal_progress(self, user_id):
            return []

    result = run_agent(
        user_id="empty-user",
        question="Where did I spend the most this month?",
        provider=EmptyProvider(),
    )
    assert "haven't logged" in result["answer"]
