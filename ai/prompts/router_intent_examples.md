# Intent Router — Few-Shot Examples (for future LLM-based routing)

Currently `ai/agents/router.py` uses deterministic keyword matching. If/when
routing moves to an LLM classifier, these are representative examples for
the few-shot prompt, aligned with docs/USER_SCENARIOS.md:

| Question | Intent |
|---|---|
| "Where did I spend the most this month?" | spending_analysis |
| "أين أنفقت أكثر هذا الشهر؟" | spending_analysis |
| "Can I afford a AED 1,200 purchase?" | recommendation |
| "How much should I save?" | recommendation |
| "What bills do I have coming up?" | bill_assistant |
| "متى فاتورة الكهرباء؟" | bill_assistant |
| "Why did my expenses increase?" | general_qa |
| "How much money do I have left this month?" | general_qa |
