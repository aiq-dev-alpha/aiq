import React, { useState } from 'react';

interface Theme {
  accent: string;
  background: string;
  card: string;
  text: string;
  muted: string;
}

interface DashboardProps {
  theme?: Partial<Theme>;
  styles?: React.CSSProperties;
}

const defaultTheme: Theme = {
  accent: '#10b981',
  background: '#ffffff',
  card: '#f8fafc',
  text: '#0f172a',
  muted: '#64748b'
};

export const DashboardScreen: React.FC<DashboardProps> = ({
  theme = {},
  styles = {}
}) => {
  const [period, setPeriod] = useState('monthly');
  const appliedTheme = { ...defaultTheme, ...theme };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.background,
    padding: '3rem',
    fontFamily: 'system-ui, sans-serif',
    ...styles
  };

  const topBarStyles: React.CSSProperties = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: '3rem',
    paddingBottom: '1.5rem',
    borderBottom: `2px solid ${appliedTheme.card}`
  };

  const metricsStyles: React.CSSProperties = {
    display: 'flex',
    gap: '2rem',
    marginBottom: '3rem'
  };

  const metricBoxStyles: React.CSSProperties = {
    flex: 1,
    backgroundColor: appliedTheme.card,
    padding: '2rem',
    borderRadius: '0.875rem',
    borderLeft: `4px solid ${appliedTheme.accent}`
  };

  return (
    <div style={containerStyles}>
      <div style={topBarStyles}>
        <div>
          <h1 style={{ fontSize: '2.25rem', fontWeight: 800, color: appliedTheme.text, marginBottom: '0.5rem' }}>Analytics Dashboard</h1>
          <p style={{ fontSize: '1rem', color: appliedTheme.muted }}>Monitor your key performance indicators</p>
        </div>
        <select
          value={period}
          onChange={(e) => setPeriod(e.target.value)}
          style={{
            padding: '0.75rem 1.5rem',
            borderRadius: '0.5rem',
            border: `1px solid ${appliedTheme.card}`,
            fontSize: '1rem',
            backgroundColor: appliedTheme.card,
            color: appliedTheme.text,
            cursor: 'pointer'
          }}
        >
          <option value="daily">Daily</option>
          <option value="weekly">Weekly</option>
          <option value="monthly">Monthly</option>
          <option value="yearly">Yearly</option>
        </select>
      </div>
      <div style={metricsStyles}>
        {[
          { title: 'Total Sales', value: '$892,340', trend: '+15.3%' },
          { title: 'New Customers', value: '3,842', trend: '+22.1%' },
          { title: 'Engagement Rate', value: '68.4%', trend: '+5.7%' }
        ].map((metric, idx) => (
          <div key={idx} style={metricBoxStyles}>
            <div style={{ fontSize: '0.875rem', color: appliedTheme.muted, marginBottom: '1rem', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.05em' }}>{metric.title}</div>
            <div style={{ fontSize: '2.5rem', fontWeight: 800, color: appliedTheme.text, marginBottom: '0.5rem' }}>{metric.value}</div>
            <div style={{ fontSize: '0.875rem', color: appliedTheme.accent, fontWeight: 600 }}>{metric.trend} from last period</div>
          </div>
        ))}
      </div>
    </div>
  );
};
