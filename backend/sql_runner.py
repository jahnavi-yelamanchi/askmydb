import re
import psycopg2.extras
from db import get_conn


def run_query(sql: str) -> dict:
    stripped = sql.strip().upper()
    if not stripped.startswith("SELECT") or re.search(
        r"\b(INSERT|UPDATE|DELETE|DROP|ALTER|CREATE|TRUNCATE|GRANT|REVOKE)\b", stripped
    ):
        raise ValueError("Only SELECT queries are allowed")

    conn = get_conn()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cur.execute(sql)
    rows = cur.fetchall()
    columns = [desc[0] for desc in cur.description]
    cur.close()
    conn.close()

    return {
        "columns": columns,
        "rows": [dict(row) for row in rows],
    }
