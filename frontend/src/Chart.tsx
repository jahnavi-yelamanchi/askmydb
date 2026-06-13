import {
  BarChart, Bar, LineChart, Line,
  XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
} from 'recharts'

interface Props {
  columns: string[]
  rows: Record<string, unknown>[]
}

function detectAxes(columns: string[], rows: Record<string, unknown>[]) {
  if (columns.length < 2 || rows.length === 0) return null

  const sample = rows[0]
  const numericCols = columns.filter((c) => typeof sample[c] === 'number')
  const stringCols = columns.filter((c) => typeof sample[c] === 'string')

  if (numericCols.length === 0) return null

  const xCol = stringCols[0] ?? columns.find((c) => !numericCols.includes(c)) ?? columns[0]
  const yCol = numericCols[0]
  const isTimeSeries = /date|month|year|time|day|week/i.test(xCol)

  return { xCol, yCol, isTimeSeries }
}

export default function Chart({ columns, rows }: Props) {
  const axes = detectAxes(columns, rows)
  if (!axes) return null

  const { xCol, yCol, isTimeSeries } = axes
  const data = rows.map((r) => ({ ...r, [xCol]: String(r[xCol]) }))

  return (
    <div className="chart-wrap">
      <div className="label">{yCol} by {xCol}</div>
      <ResponsiveContainer width="100%" height={280}>
        {isTimeSeries ? (
          <LineChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke="#21262d" />
            <XAxis dataKey={xCol} tick={{ fill: '#8b949e', fontSize: 12 }} />
            <YAxis tick={{ fill: '#8b949e', fontSize: 12 }} />
            <Tooltip contentStyle={{ background: '#161b22', border: '1px solid #30363d', borderRadius: 6 }} />
            <Line type="monotone" dataKey={yCol} stroke="#58a6ff" strokeWidth={2} dot={false} />
          </LineChart>
        ) : (
          <BarChart data={data}>
            <CartesianGrid strokeDasharray="3 3" stroke="#21262d" />
            <XAxis dataKey={xCol} tick={{ fill: '#8b949e', fontSize: 12 }} />
            <YAxis tick={{ fill: '#8b949e', fontSize: 12 }} />
            <Tooltip contentStyle={{ background: '#161b22', border: '1px solid #30363d', borderRadius: 6 }} />
            <Bar dataKey={yCol} fill="#238636" radius={[3, 3, 0, 0]} />
          </BarChart>
        )}
      </ResponsiveContainer>
    </div>
  )
}
