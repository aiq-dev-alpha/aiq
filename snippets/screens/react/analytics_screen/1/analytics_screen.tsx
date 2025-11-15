import React, { useState } from 'react';

interface Theme {
  backgroundColor: string;
  cardBackground: string;
  primaryColor: string;
  textPrimary: string;
  textSecondary: string;
}

interface MetricCard {
  title: string;
  value: string;
  change: string;
  trend: 'up' | 'down';
  icon: string;
}

interface AnalyticsProps {
  theme?: Partial<Theme>;
}

const defaultTheme: Theme = {
  backgroundColor: '#f9fafb',
  cardBackground: '#ffffff',
  primaryColor: '#3b82f6',
  textPrimary: '#111827',
  textSecondary: '#6b7280'
};

const metrics: MetricCard[] = [
  { title: 'Total Views', value: '45,231', change: '+12.5%', trend: 'up', icon: '👁' },
  { title: 'Unique Visitors', value: '12,543', change: '+8.2%', trend: 'up', icon: '👥' },
  { title: 'Bounce Rate', value: '32.4%', change: '-2.1%', trend: 'down', icon: '📊' },
  { title: 'Avg. Duration', value: '4:23', change: '+15.3%', trend: 'up', icon: '⏱' }
];

export const AnalyticsScreen: React.FC<AnalyticsProps> = ({ theme = {} }) => {
  const [timeRange, setTimeRange] = useState('7d');
  const appliedTheme = { ...defaultTheme, ...theme };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.backgroundColor,
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif'
  };

  const headerStyles: React.CSSProperties = {
    marginBottom: '2rem'
  };

  const gridStyles: React.CSSProperties = {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 1fr))',
    gap: '1.5rem',
    marginBottom: '2rem'
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.cardBackground,
    padding: '1.5rem',
    borderRadius: '0.75rem',
    boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
  };

  return (
    <div style={containerStyles}>
      <div style={headerStyles}>
        <h1 style={{ fontSize: '2rem', fontWeight: 700, marginBottom: '0.5rem', color: appliedTheme.textPrimary }}>
          Analytics Dashboard
        </h1>
        <p style={{ color: appliedTheme.textSecondary }}>Monitor your key metrics and performance</p>
      </div>

      <div style={gridStyles}>
        {metrics.map((metric, idx) => (
          <div key={idx} style={cardStyles}>
            <div style={{ fontSize: '2rem', marginBottom: '0.5rem' }}>{metric.icon}</div>
            <div style={{ fontSize: '0.875rem', color: appliedTheme.textSecondary, marginBottom: '0.5rem' }}>
              {metric.title}
            </div>
            <div style={{ fontSize: '2rem', fontWeight: 700, color: appliedTheme.textPrimary, marginBottom: '0.5rem' }}>
              {metric.value}
            </div>
            <div style={{ fontSize: '0.875rem', color: metric.trend === 'up' ? '#10b981' : '#ef4444' }}>
              {metric.change}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
