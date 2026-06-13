import os
import psycopg2
import psycopg2.extras
from functools import lru_cache

def get_conn():
    return psycopg2.connect(os.environ["DATABASE_URL"])

@lru_cache(maxsize=1)
def get_schema() -> str:
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("""
        SELECT table_name, column_name, data_type
        FROM information_schema.columns
        WHERE table_schema = 'public'
        ORDER BY table_name, ordinal_position
    """)
    rows = cur.fetchall()
    cur.close()
    conn.close()

    tables: dict[str, list[tuple[str, str]]] = {}
    for table, col, dtype in rows:
        tables.setdefault(table, []).append((col, dtype))

    def fmt_table(t: str, cols: list[tuple[str, str]]) -> str:
        col_str = ", ".join('"' + c + '" ' + dt for c, dt in cols)
        return '"' + t + '"(' + col_str + ')'

    return "\n".join(fmt_table(t, cols) for t, cols in tables.items())
