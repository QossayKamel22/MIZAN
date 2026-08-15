import logging
import sys


def configure_logging(debug: bool = False) -> None:
    """Structured-ish logging setup. Deliberately never logs request bodies
    or financial values (docs/SECURITY_REQUIREMENTS.md §9) — call sites log
    identifiers (e.g., transaction_id), not amounts/categories/PII."""
    level = logging.DEBUG if debug else logging.INFO
    logging.basicConfig(
        level=level,
        format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
        stream=sys.stdout,
    )


def get_logger(name: str) -> logging.Logger:
    return logging.getLogger(name)
