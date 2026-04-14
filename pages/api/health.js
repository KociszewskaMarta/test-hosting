// API Route to check database connectivity
export default function handler(req, res) {
  // Simple health check - in production, verify actual DB connection
  res.status(200).json({
    status: 'ok',
    timestamp: new Date().toISOString(),
    app: 'Next.js Self-Hosted',
  })
}
