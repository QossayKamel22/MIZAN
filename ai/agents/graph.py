from __future__ import annotations

from typing import Any

from ai.agents.nodes import (
    bill_assistant_node,
    general_qa_node,
    recommendation_node,
    spending_analysis_node,
    synthesis_node,
)
from ai.agents.router import classify_intent
from ai.agents.state import AgentState
from ai.tools.data_provider import FinanceDataProvider, FixtureDataProvider

try:
    from langgraph.graph import END, StateGraph

    _LANGGRAPH_AVAILABLE = True
except ImportError:  # pragma: no cover - exercised when langgraph isn't installed
    _LANGGRAPH_AVAILABLE = False


_NODE_BY_INTENT = {
    "spending_analysis": spending_analysis_node.run,
    "recommendation": recommendation_node.run,
    "bill_assistant": bill_assistant_node.run,
    "general_qa": general_qa_node.run,
}


def _build_graph(provider: FinanceDataProvider):
    """Builds the LangGraph StateGraph described in
    docs/AI_AGENT_ARCHITECTURE.md §3: router → capability node → synthesis.
    Adding a capability means adding a node + a routing branch here —
    the rest of the graph is untouched (NFR-SCALE-2)."""
    graph = StateGraph(AgentState)

    graph.add_node("router", classify_intent)
    for intent, node_fn in _NODE_BY_INTENT.items():
        graph.add_node(intent, lambda state, fn=node_fn: fn(state, provider))
    graph.add_node("synthesis", synthesis_node.run)

    graph.set_entry_point("router")
    graph.add_conditional_edges("router", lambda state: state["intent"], {
        intent: intent for intent in _NODE_BY_INTENT
    })
    for intent in _NODE_BY_INTENT:
        graph.add_edge(intent, "synthesis")
    graph.add_edge("synthesis", END)

    return graph.compile()


def _run_without_langgraph(state: AgentState, provider: FinanceDataProvider) -> AgentState:
    """Fallback execution path with identical node sequencing, used when the
    `langgraph` package isn't installed in the current environment (this
    sandbox has no network access to pip-install it at runtime). Produces
    the same result as the compiled graph — same nodes, same order — so
    behavior doesn't silently differ between environments."""
    state = classify_intent(state)
    node_fn = _NODE_BY_INTENT[state["intent"]]
    state = node_fn(state, provider)
    state = synthesis_node.run(state)
    return state


def run_agent(
    *,
    user_id: str,
    question: str,
    language: str = "en",
    ai_configured: bool = False,
    provider: FinanceDataProvider | None = None,
) -> dict[str, Any]:
    """Entry point called by `backend/app/api/v1/endpoints/ai.py`.

    `ai_configured` reflects whether a live LLM provider key is present
    (docs/AI_AGENT_ARCHITECTURE.md §6). Tool retrieval and grounding work
    identically either way; only the synthesis step would swap from the
    deterministic template to a real LLM call once configured — see
    `ai/agents/nodes/synthesis_node.py` docstring.
    """
    provider = provider or FixtureDataProvider()
    initial_state: AgentState = {
        "user_id": user_id,
        "question": question,
        "language": language,
        "intent": None,
        "tool_results": [],
        "answer": None,
    }

    if _LANGGRAPH_AVAILABLE:
        compiled = _build_graph(provider)
        final_state = compiled.invoke(initial_state)
    else:
        final_state = _run_without_langgraph(initial_state, provider)

    tools_used = [r["tool"] for r in final_state.get("tool_results", [])]
    return {
        "answer": final_state["answer"],
        "tools_used": tools_used,
        "language": language,
        "intent": final_state.get("intent"),
    }
