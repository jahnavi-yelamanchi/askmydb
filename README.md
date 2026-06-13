# AskMyDB

**Natural-language → SQL analytics copilot.** Ask questions in plain English, get the SQL, a chart, and a results table — instantly.

**Live demo → [askmydb.up.railway.app](https://askmydb.up.railway.app)**

---

![AskMyDB demo](screenshots/demo.png)

---

## What it does

Type any question about the database in plain English. AskMyDB:

1. Introspects the live schema and injects it into the prompt
2. Calls the OpenAI API with function calling — the model is forced to return a `run_sql(query)` tool call
3. Validates the query is read-only (`SELECT` only), then executes it against Postgres
4. Returns the generated SQL, an auto-rendered chart, and a full results table

No query builder. No dropdowns. Just English.

---

## Eval results

Evaluated on a 15-case NL→SQL test suite (Spider-style, hand-curated for the Chinook schema). Accuracy is measured by **execution accuracy** — result sets are compared, not SQL strings, so equivalent queries pass.

```
Execution accuracy: 14/15 (93%)
```

Run it yourself:
```bash
cd evals
DATABASE_URL=postgresql://askmydb:askmydb@localhost:5432/askmydb python eval.py
```

---

## Features

**Schema-aware prompting** — on startup the backend queries `information_schema` and builds a compact schema string (`"Artist"("ArtistId" integer, "Name" character varying, ...)`). This is injected into every prompt so the model never hallucinates table or column names.

**OpenAI function calling** — instead of parsing free-text SQL out of a completion, the model is constrained to call a single tool: `run_sql(query: str)`. The SQL comes back structured, not as a string to regex out of prose.

**Read-only enforcement** — every query is validated server-side before execution. Anything that isn't a `SELECT` is rejected with a 400.

**Auto-chart** — the frontend inspects the result columns and auto-selects chart type: string + numeric → bar chart, date/time column + numeric → line chart. No configuration needed.

---

## Screenshots

### Line chart (time series)
![Monthly sales](screenshots/monthly-sales.png)

### Schema-aware SQL generation
![Generated SQL](screenshots/generated-sql.png)

---

## Tech stack

| Layer | Tech |
|---|---|
| LLM | OpenAI `gpt-4o-mini` with function calling |
| Backend | FastAPI · Python 3.12 |
| Database | PostgreSQL 16 (Chinook-style music store schema) |
| Frontend | React 18 · TypeScript · Vite |
| Charts | Recharts |
| Deploy | Railway (backend + frontend + Postgres) |
| Containers | Docker · Docker Compose |

---

## Demo database

Ships with a [Chinook][chinook]-inspired music store: **Artists → Albums → Tracks → Customers → Invoices → InvoiceLines**. Good for revenue, popularity, and time-series queries out of the box.

Example questions that work well:
- *Top 5 artists by total revenue*
- *Monthly sales totals in 2021*
- *Which album has the highest average track price?*
- *Customers by country*
- *Most purchased tracks*

---

## Architecture

```
Browser (React + Recharts)
        │  POST /query { question }
        ▼
    FastAPI (Python)
        │  schema string injected into system prompt
        ▼
  OpenAI gpt-4o-mini
   function calling → run_sql(query)
        │
        ▼
  Query validation (SELECT only)
        │
        ▼
  PostgreSQL (read-only role)
        │
        ▼
  { sql, columns, rows } → JSON
```

---

## Run locally

**Prerequisites:** Docker, an OpenAI API key

```bash
git clone https://github.com/jahnavi-yelamanchi/askmydb
cd askmydb

# Add your key
cp .env.example .env
echo "OPENAI_API_KEY=sk-..." >> .env

# Start everything
docker compose up --build
```

Open [localhost:3000](http://localhost:3000).

**Dev mode** (faster iteration):

```bash
# Terminal 1 — DB only
docker compose up db

# Terminal 2 — Backend
cd backend
pip install -r requirements.txt
DATABASE_URL=postgresql://askmydb:askmydb@localhost:5432/askmydb \
OPENAI_API_KEY=sk-... uvicorn main:app --reload

# Terminal 3 — Frontend
cd frontend
npm install && npm run dev
# → http://localhost:5173
```

---

## Project structure

```
askmydb/
├── backend/
│   ├── main.py          # FastAPI app + startup seeding
│   ├── db.py            # Postgres connection + schema introspection
│   ├── llm.py           # OpenAI function-calling prompt
│   ├── sql_runner.py    # Read-only query execution
│   └── seed.sql         # Demo database seed
├── frontend/
│   └── src/
│       ├── App.tsx      # Query input + results table
│       └── Chart.tsx    # Auto-chart (bar / line)
├── evals/
│   └── eval.py          # Execution-accuracy eval
└── docker-compose.yml
```

---

## References

- [Chinook Database][chinook] — open-source sample database modelling a digital music store, widely used for SQL demos and benchmarks
- [Spider benchmark][spider] — large-scale NL→SQL dataset used as the standard for text-to-SQL evaluation
- [OpenAI function calling][fn-calling] — structured output mechanism used to force the model to return valid SQL rather than free-text
- [FastAPI][fastapi] — Python web framework used for the backend API
- [Recharts][recharts] — composable charting library for React

[chinook]: https://github.com/lerocha/chinook-database
[spider]: https://yale-lily.github.io/spider
[fn-calling]: https://platform.openai.com/docs/guides/function-calling
[fastapi]: https://fastapi.tiangolo.com
[recharts]: https://recharts.org
