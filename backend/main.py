import os
from dotenv import load_dotenv
load_dotenv()

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from llm import nl_to_sql
from sql_runner import run_query

app = FastAPI()


@app.on_event("startup")
def seed_on_startup():
    import os as _os
    seed_path = _os.path.join(_os.path.dirname(__file__), "seed.sql")
    if not _os.path.exists(seed_path):
        return
    from db import get_conn
    conn = get_conn()
    cur = conn.cursor()
    cur.execute('SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=\'public\' AND table_name=\'Artist\'')
    exists = cur.fetchone()[0]
    if not exists:
        with open(seed_path) as f:
            cur.execute(f.read())
        conn.commit()
    cur.close()
    conn.close()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


class QueryRequest(BaseModel):
    question: str


@app.post("/query")
def query(req: QueryRequest):
    try:
        sql = nl_to_sql(req.question)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"LLM error: {e}")
    try:
        result = run_query(sql)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Query error: {e}")
    return {"sql": sql, **result}


@app.get("/health")
def health():
    return {"status": "ok"}
