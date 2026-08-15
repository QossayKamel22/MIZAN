# MIZAN Backend

FastAPI backend for MIZAN. See root `docs/API_SPECIFICATION.md`, `docs/TECHNICAL_ARCHITECTURE.md` §2, and `docs/DATABASE_DESIGN.md`.

## Setup
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-dev.txt
cp ../.env.example ../.env   # fill in real values
alembic upgrade head
uvicorn app.main:app --reload
```

## Testing
```bash
pytest --cov=app
```

## Status
See root `docs/FINAL_TECHNICAL_REPORT.md` for exactly what is implemented vs. pending (Firebase project, live LLM key, deployed Postgres).
