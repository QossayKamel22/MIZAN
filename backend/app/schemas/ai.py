from pydantic import BaseModel


class AskRequest(BaseModel):
    question: str


class AskResponse(BaseModel):
    answer: str
    tools_used: list[str] = []
    language: str = "en"


class InsightResponse(BaseModel):
    insights: list[str]
