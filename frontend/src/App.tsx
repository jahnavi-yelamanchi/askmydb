import { useState } from 'react'
import Chart from './Chart'

interface QueryResult {
  sql: string
  columns: string[]
  rows: Record<string, unknown>[]
}

const SUGGESTIONS = [
  'Top 5 artists by total revenue',
  'Monthly sales totals in 2021',
  'Customers by country',
  'Most purchased tracks',
  'Average invoice total by country',
]

const API = import.meta.env.VITE_API_URL ?? '/api'

export default function App() {
  const [question, setQuestion] = useState('')
  const [result, setResult] = useState<QueryResult | null>(null)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  async function ask(q: string) {
    if (!q.trim()) return
    setLoading(true)
    setError('')
    setResult(null)
    try {
      const res = await fetch(`${API}/query`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ question: q }),
      })
      if (!res.ok) {
        const data = await res.json()
        throw new Error(data.detail ?? 'Request failed')
      }
      setResult(await res.json())
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Unknown error')
    } finally {
      setLoading(false)
    }
  }

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault()
    ask(question)
  }

  return (
    <>
      <h1>AskMyDB</h1>
      <p className="subtitle">Ask questions about your data in plain English → get SQL + results instantly</p>

      <form className="input-row" onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="e.g. Top 5 artists by total revenue"
          value={question}
          onChange={(e) => setQuestion(e.target.value)}
          autoFocus
        />
        <button type="submit" disabled={loading}>
          {loading && <span className="spinner" />}
          {loading ? 'Running…' : 'Ask'}
        </button>
      </form>

      <div className="suggestions">
        {SUGGESTIONS.map((s) => (
          <button
            key={s}
            className="suggestion"
            type="button"
            onClick={() => { setQuestion(s); ask(s) }}
          >
            {s}
          </button>
        ))}
      </div>

      {error && <div className="error">{error}</div>}

      {result && (
        <>
          <div className="label">Generated SQL</div>
          <div className="sql-block">{result.sql}</div>

          {result.rows.length > 0 && (
            <Chart columns={result.columns} rows={result.rows} />
          )}

          <div className="label">Results — {result.rows.length} row{result.rows.length !== 1 ? 's' : ''}</div>
          <table>
            <thead>
              <tr>{result.columns.map((c) => <th key={c}>{c}</th>)}</tr>
            </thead>
            <tbody>
              {result.rows.map((row, i) => (
                <tr key={i}>
                  {result.columns.map((c) => (
                    <td key={c}>{String(row[c] ?? '')}</td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        </>
      )}
    </>
  )
}
