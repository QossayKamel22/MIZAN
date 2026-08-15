# MIZAN AI Agent Layer

LangGraph-based agent architecture. See root `docs/AI_AGENT_ARCHITECTURE.md`.

## Verified in this build
`ai/tests/` passes against a real (installed) `langgraph` — not just written, actually executed:

```
python3 -m pytest ai/tests -v
```

Router intent classification and end-to-end `run_agent()` calls are both covered, including a
groundedness test (`test_run_agent_never_fabricates_when_no_data`) that asserts the agent
never states figures it wasn't given.

## Status
Tool retrieval and grounded-answer synthesis work today against `FixtureDataProvider`.
Live LLM synthesis and a production `BackendFinanceDataProvider` (wired to real user data via
`backend/app/repositories/`) are pending an LLM provider key and DB-backed provider
implementation — see `docs/FINAL_TECHNICAL_REPORT.md`.
