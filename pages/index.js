import { useState, useEffect } from 'react'

export default function Home() {
  const [supabaseConnected, setSupabaseConnected] = useState(false)
  const [loading, setLoading] = useState(true)
  const [projectInfo, setProjectInfo] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    const checkConnection = async () => {
      try {
        // Check if Supabase environment variables are set
        const url = process.env.NEXT_PUBLIC_SUPABASE_URL
        const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

        if (!url || !key) {
          setError('Supabase credentials not configured')
          setLoading(false)
          return
        }

        // Try to fetch from Supabase REST API (health check endpoint)
        const response = await fetch(`${url}/rest/v1/`, {
          headers: {
            'apikey': key,
          }
        })

        if (response.ok || response.status === 401 || response.status === 404) {
          // If we get any of these responses, it means Supabase is reachable
          setSupabaseConnected(true)
          setProjectInfo({
            url: url,
            project: url.split('.')[0]?.replace('https://', '')
          })
        } else {
          setError(`HTTP ${response.status}`)
        }
      } catch (err) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    checkConnection()
  }, [])

  return (
    <div style={styles.container}>
      <h1>Self-Hosting Test</h1>
      <p>Next.js + Cloud Supabase</p>
      
      <div style={styles.statusBox}>
        <h2>Status</h2>
        {loading ? (
          <p>Connecting to Supabase...</p>
        ) : (
          <>
            <p>
              Next.js App: <span style={styles.success}>✓ Running</span>
            </p>
            <p>
              Cloud Supabase: {supabaseConnected ? (
                <span style={styles.success}>✓ Connected</span>
              ) : (
                <span style={styles.error}>✗ Connection Failed</span>
              )}
            </p>
            {error && (
              <p style={styles.error}>Error: {error}</p>
            )}
          </>
        )}
      </div>

      {projectInfo && (
        <div style={styles.infoBox}>
          <h2>Project Information</h2>
          <p><strong>Project ID:</strong> {projectInfo.project}</p>
          <p><strong>URL:</strong> {projectInfo.url}</p>
          <p>
            <strong>Manage Database:</strong>{' '}
            <a 
              href="https://app.supabase.com" 
              target="_blank" 
              rel="noopener noreferrer"
            >
              Open Supabase Dashboard
            </a>
          </p>
        </div>
      )}

      <div style={styles.infoBox}>
        <h2>About This Setup</h2>
        <ul>
          <li>✓ Next.js Application (Self-hosted via Docker)</li>
          <li>✓ PostgreSQL Database (Cloud Supabase)</li>
          <li>✓ Simplified Deployment</li>
        </ul>
      </div>
    </div>
  )
}

const styles = {
  container: {
    maxWidth: '800px',
    margin: '0 auto',
    padding: '2rem',
    fontFamily: '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
  },
  statusBox: {
    border: '1px solid #ddd',
    borderRadius: '8px',
    padding: '1rem',
    marginTop: '1rem',
    backgroundColor: '#f9f9f9',
  },
  infoBox: {
    border: '1px solid #ddd',
    borderRadius: '8px',
    padding: '1rem',
    marginTop: '1rem',
    backgroundColor: '#f0f7ff',
  },
  success: {
    color: '#22c55e',
    fontWeight: 'bold',
  },
  error: {
    color: '#ef4444',
    fontWeight: 'bold',
  },
}
