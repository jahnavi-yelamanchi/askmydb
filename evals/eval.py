"""
Execution-accuracy eval on a small NL→SQL test set.
Compares result sets (not SQL strings) so equivalent queries pass.

Usage:
  DATABASE_URL=... EVAL_API=http://localhost:8000 python evals/eval.py
"""
import os
import json
import urllib.request
import psycopg2
import psycopg2.extras

DATABASE_URL = os.environ.get("DATABASE_URL", "postgresql://askmydb:askmydb@localhost:5432/askmydb")
API = os.environ.get("EVAL_API", "http://localhost:8000")

TEST_CASES = [
    ("How many artists are there?",
     'SELECT COUNT(*) FROM "Artist"'),
    ("List all countries customers come from",
     'SELECT DISTINCT "Country" FROM "Customer" ORDER BY "Country"'),
    ("What is the total revenue from all invoices?",
     'SELECT ROUND(SUM("Total")::numeric, 2) AS total_revenue FROM "Invoice"'),
    ("How many invoices were placed in 2021?",
     "SELECT COUNT(*) FROM \"Invoice\" WHERE EXTRACT(YEAR FROM \"InvoiceDate\") = 2021"),
    ("Which artist has the most albums?",
     'SELECT a."Name", COUNT(al."AlbumId") as album_count FROM "Artist" a JOIN "Album" al ON a."ArtistId" = al."ArtistId" GROUP BY a."Name" ORDER BY album_count DESC LIMIT 1'),
    ("What are the top 3 countries by number of customers?",
     'SELECT "Country", COUNT(*) as customer_count FROM "Customer" GROUP BY "Country" ORDER BY customer_count DESC LIMIT 3'),
    ("What is the average invoice total?",
     'SELECT AVG("Total") AS avg_total FROM "Invoice"'),
    ("How many tracks are there in total?",
     'SELECT COUNT(*) FROM "Track"'),
    ("What is the most expensive track?",
     'SELECT "Name", "UnitPrice" FROM "Track" ORDER BY "UnitPrice" DESC LIMIT 1'),
    ("List all albums by Led Zeppelin",
     'SELECT al."Title" FROM "Album" al JOIN "Artist" a ON al."ArtistId" = a."ArtistId" WHERE a."Name" = \'Led Zeppelin\' ORDER BY al."Title"'),
    ("How many customers are from Brazil?",
     'SELECT COUNT(*) FROM "Customer" WHERE "Country" = \'Brazil\''),
    ("What is the total revenue per year?",
     'SELECT EXTRACT(YEAR FROM "InvoiceDate") AS year, ROUND(SUM("Total")::numeric, 2) AS revenue FROM "Invoice" GROUP BY year ORDER BY year'),
    ("How many albums does Metallica have?",
     'SELECT COUNT(*) FROM "Album" al JOIN "Artist" a ON al."ArtistId" = a."ArtistId" WHERE a."Name" = \'Metallica\''),
    ("Show total revenue by country",
     'SELECT c."Country", ROUND(SUM(i."Total")::numeric, 2) AS revenue FROM "Customer" c JOIN "Invoice" i ON c."CustomerId" = i."CustomerId" GROUP BY c."Country" ORDER BY revenue DESC'),
    ("What are the top 5 artists by total revenue?",
     'SELECT a."Name", SUM(i."Total") AS revenue FROM "Artist" a JOIN "Album" al ON a."ArtistId" = al."ArtistId" JOIN "Track" t ON al."AlbumId" = t."AlbumId" JOIN "InvoiceLine" il ON t."TrackId" = il."TrackId" JOIN "Invoice" i ON il."InvoiceId" = i."InvoiceId" GROUP BY a."Name" ORDER BY revenue DESC LIMIT 5'),
]


def run_sql(sql: str) -> list:
    conn = psycopg2.connect(DATABASE_URL)
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cur.execute(sql)
    rows = [dict(r) for r in cur.fetchall()]
    cur.close()
    conn.close()
    return rows


def call_api(question: str) -> list | None:
    payload = json.dumps({"question": question}).encode()
    req = urllib.request.Request(
        f"{API}/query",
        data=payload,
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=30) as resp:
            data = json.loads(resp.read())
            return data.get("rows", [])
    except Exception as e:
        print(f"    API error: {e}")
        return None


def _fmt(v: object) -> str:
    try:
        return str(round(float(v), 2))  # type: ignore[arg-type]
    except (TypeError, ValueError):
        return str(v)

def normalize(rows: list) -> list:
    return sorted([sorted(_fmt(v) for v in r.values()) for r in rows])


def main():
    correct = 0
    total = len(TEST_CASES)

    print(f"\nRunning {total} eval cases against {API}\n{'─'*55}")
    for i, (question, expected_sql) in enumerate(TEST_CASES, 1):
        expected = run_sql(expected_sql)
        actual = call_api(question)

        if actual is None:
            status = "ERROR"
        elif normalize(expected) == normalize(actual):
            status = "PASS"
            correct += 1
        else:
            status = "FAIL"

        print(f"[{i:02d}] {status:5s}  {question}")

    pct = correct / total * 100
    print(f"\n{'─'*55}")
    print(f"Execution accuracy: {correct}/{total} ({pct:.0f}%)\n")


if __name__ == "__main__":
    main()
