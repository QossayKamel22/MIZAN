# MIZAN — AI Agent Architecture

## 1. Design Principles
1. **Grounded, not generative-fabricated**: agents answer using data retrieved through tools, never invent financial figures.
2. **Scoped by user**: every tool call is parameterized by the authenticated `user_id`; the agent has no path to another user's data.
3. **Modular graph**: new capabilities are added as new nodes/tools without rewriting the existing graph (NFR-SCALE-2).
4. **Transparent limitations**: unimplemented capabilities are documented in §6, never silently faked in the UI (project-wide "no fake completion" rule).

## 2. Technology
- **LangGraph** for the stateful agent graph (routing, tool orchestration, cycles where needed for multi-step reasoning).
- **LLM provider**: configurable via `AI_PROVIDER`/`AI_MODEL_NAME` env vars (Anthropic Claude by default; OpenAI-compatible as an alternative).
- Implemented as a Python package under `ai/`, imported by the backend's `/ai/*` endpoints (in-process call in v1, extractable to a separate service later without changing the tool contracts).

## 3. Graph Design

```
                     ┌───────────────┐
   user question ──► │ Intent Router  │
                     └──────┬────────┘
             ┌──────────────┼────────────────┬───────────────┐
             ▼               ▼                 ▼                ▼
   ┌────────────────┐ ┌──────────────┐ ┌─────────────────┐ ┌───────────────┐
   │ Spending        │ │ Recommendation│ │ Bill Assistant   │ │ General Q&A    │
   │ Analysis Node    │ │ Node          │ │ Node             │ │ Node            │
   └───────┬─────────┘ └──────┬───────┘ └────────┬─────────┘ └───────┬───────┘
           │                   │                   │                   │
           ▼                   ▼                   ▼                   ▼
       [tool calls]        [tool calls]        [tool calls]        [tool calls]
           │                   │                   │                   │
           └───────────────────┴─────────┬─────────┴───────────────────┘
                                          ▼
                                 ┌─────────────────┐
                                 │ Synthesis Node    │
                                 │ (compose final     │
                                 │  grounded reply)   │
                                 └─────────┬─────────┘
                                          ▼
                                   response to user
```

- **Intent Router**: classifies the question into one of the capability nodes (or a blended path) using the LLM with a constrained system prompt + few-shot examples (see `ai/prompts/`).
- **Capability nodes**: each is a bounded LangGraph node that decides which tool(s) to call and with what arguments, executes them, and passes structured results downstream.
- **Synthesis Node**: takes all tool outputs collected in the shared `AgentState` and produces the final natural-language answer, in the user's selected language, with a disclaimer appended when the answer touches recommendations (not raw factual lookups).

## 4. Agent State (`ai/agents/state.py`)
```python
class AgentState(TypedDict):
    user_id: str
    question: str
    language: str              # "ar" | "en"
    intent: str | None
    tool_results: list[dict]   # accumulated structured tool outputs
    answer: str | None
```

## 5. Tools (`ai/tools/`)
Each tool is a thin, typed wrapper calling the backend's service layer (same code path as the REST API uses, imported directly — no HTTP hop within the process):

| Tool | Purpose |
|---|---|
| `get_spending_by_category(user_id, period)` | Category-level expense breakdown for a period |
| `get_income_vs_expense(user_id, period)` | Income/expense totals and delta vs. prior period |
| `get_budget_status(user_id, budget_id=None)` | Current budget(s) spent/remaining/percent |
| `get_upcoming_bills(user_id, horizon_days)` | Bills due within a horizon |
| `get_goal_progress(user_id, goal_id=None)` | Savings goal progress |
| `get_unusual_transactions(user_id, period)` | Transactions statistically deviating from the user's own historical pattern |

Adding a capability = adding a tool + (if needed) a routing branch — the graph shape does not need to change (NFR-SCALE-2).

## 6. Capability Status

### Implemented in this build (real, tool-grounded)
- Graph structure, state schema, routing skeleton, and tool interfaces (this repository).
- Tool implementations calling the backend's real data-access layer (see `backend/app/services/`).

### Documented as Future / Pending (per "no fake completion")
These are **explicitly not claimed as working** in the current build and must not be exposed as functional UI without the underlying implementation:
- Live LLM API calls require a provisioned `ANTHROPIC_API_KEY`/`OPENAI_API_KEY` (external credential — see `FINAL_TECHNICAL_REPORT.md` for pending-items list).
- Multi-turn conversational memory persisted across sessions (v1 keeps memory within a single request/session only).
- Actionable bill payments initiated by the assistant (v1 is informational only — MIZAN does not move money).
- Proactive push-triggered insights beyond the basic budget-threshold and bill-due triggers already covered by `services/notification_service.py`.
- Personalized recommendation tuning based on long-horizon behavioral history (requires a feedback/labeling loop, future phase).

## 7. Safety & Guardrails
- System prompts (see `ai/prompts/`) explicitly instruct the model to only state figures returned by tools, to say "I don't have enough data" rather than guess, and to append a financial-disclaimer suffix on recommendation-type answers.
- Rate limiting at the API layer (`/ai/ask`, see `API_SPECIFICATION.md` §11) bounds cost and abuse.
- No tool grants write access — all agent tools in v1 are read-only against user data; the assistant cannot create/modify/delete financial records (reduces blast radius of any agent misbehavior). This is a deliberate scope decision, revisited in a future phase per `security-expert`/`ai-agent-engineer` guidance.
- Prompt-injection consideration: user-provided free text (the question) is treated as untrusted input to the LLM but is never interpolated into tool arguments without validation (e.g., a `period` argument is parsed/validated server-side, not passed through raw).

## 8. Evaluation (Planned)
A lightweight eval set of representative user questions (see `TESTING_STRATEGY.md` §5) with expected tool-call traces, to catch regressions in intent routing and groundedness as prompts evolve.
