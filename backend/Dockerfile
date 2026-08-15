# Multi-stage build (docs/DEPLOYMENT_PLAN.md §2)
FROM python:3.12-slim AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

FROM python:3.12-slim AS runtime

WORKDIR /app
ENV PYTHONUNBUFFERED=1 \
    PATH=/root/.local/bin:$PATH

COPY --from=builder /root/.local /root/.local
COPY . .
# The AI agent package lives at the repo root, one level above backend/ —
# copy it in so `from ai.agents.graph import run_agent` resolves the same
# way it does in local development (see app/api/v1/endpoints/ai.py).
COPY ../ai /app/ai

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
