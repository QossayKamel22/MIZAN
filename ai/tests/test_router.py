import json
from pathlib import Path

from ai.agents.router import classify_intent

_EVAL_SET = json.loads((Path(__file__).parent / "eval_questions.json").read_text())


def test_router_matches_expected_intent_for_eval_set():
    for case in _EVAL_SET:
        state = {"question": case["question"], "user_id": "test-user", "language": "en"}
        result = classify_intent(state)
        assert result["intent"] == case["expected_intent"], case["question"]
