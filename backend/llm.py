import json
import os
from openai import OpenAI
from db import get_schema

client = OpenAI(api_key=os.environ["OPENAI_API_KEY"])

TOOLS = [
    {
        "type": "function",
        "function": {
            "name": "run_sql",
            "description": "Execute a read-only SQL SELECT query on the PostgreSQL database and return results.",
            "parameters": {
                "type": "object",
                "properties": {
                    "query": {
                        "type": "string",
                        "description": "A valid PostgreSQL SELECT query",
                    }
                },
                "required": ["query"],
            },
        },
    }
]


def nl_to_sql(question: str) -> str:
    schema = get_schema()
    system = f"""You are a SQL expert. Convert the user's question to a PostgreSQL SELECT query.
Only use tables and columns that exist in the schema below. Never write INSERT, UPDATE, DELETE, or DDL.
Always call the run_sql function with your query.

IMPORTANT: All table names and column names are case-sensitive and MUST always be wrapped in double quotes.
For example: SELECT "Artist"."Name" FROM "Artist" — never write FROM Artist or FROM artist.

Schema:
{schema}"""

    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": system},
            {"role": "user", "content": question},
        ],
        tools=TOOLS,
        tool_choice={"type": "function", "function": {"name": "run_sql"}},
    )

    tool_call = response.choices[0].message.tool_calls[0]
    args = json.loads(tool_call.function.arguments)
    return args["query"]
