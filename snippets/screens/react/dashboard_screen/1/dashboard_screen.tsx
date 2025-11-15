import React, { useState } from 'react';

interface Theme {
  backgroundColor: string;
  cardBackground: string;
  textPrimary: string;
  textSecondary: string;
  accentColor: string;
}

interface DashboardProps {
  theme?: Partial<Theme>;
  styles?: React.CSSProperties;
}

const defaultTheme: Theme = {
  backgroundColor: '#f9fafb',
  cardBackground: '#ffffff',
  textPrimary: '#111827',
  textSecondary: '#6b7280',
  accentColor: '#3b82f6'
};

export const DashboardScreen: React.FC<DashboardProps> = ({
  theme = {},
  styles = {}
}) => {
  const [timeframe, setTimeframe] = useState('week');
  const appliedTheme = { ...defaultTheme, ...theme };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.backgroundColor,
    padding: '2rem',
    fontFamily: 'system-ui, sans-serif',
    ...styles
  };

  const headerStyles: React.CSSProperties = {
    marginBottom: '2rem'
  };

  const titleStyles: React.CSSProperties = {
    fontSize: '2rem',
    fontWeight: 700,
    color: appliedTheme.textPrimary,
    marginBottom: '0.5rem'
  };

  const subtitleStyles: React.CSSProperties = {
    fontSize: '1rem',
    color: appliedTheme.textSecondary
  };

  const gridStyles: React.CSSProperties = {
    display: 'grid',
    gridTemplateColumns: 'repeat(auto-fit, minmax(250px, 1fr))',
    gap: '1.5rem',
    marginBottom: '2rem'
  };

  const cardStyles: React.CSSProperties = {
    backgroundColor: appliedTheme.cardBackground,
    padding: '1.5rem',
    borderRadius: '0.75rem',
    boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
  };

  const cardTitleStyles: React.CSSProperties = {
    fontSize: '0.875rem',
    fontWeight: 600,
    color: appliedTheme.textSecondary,
    marginBottom: '0.5rem',
    textTransform: 'uppercase',
    letterSpacing: '0.05em'
  };

  const cardValueStyles: React.CSSProperties = {
    fontSize: '2rem',
    fontWeight: 700,
    color: appliedTheme.textPrimary,
    marginBottom: '0.25rem'
  };

  const cardChangeStyles: React.CSSProperties = {
    fontSize: '0.875rem',
    color: '#10b981'
  };

  const chartCardStyles: React.CSSProperties = {
    ...cardStyles,
    gridColumn: 'span 2'
  };

  const filterStyles: React.CSSProperties = {
    display: 'flex',
    gap: '0.5rem',
    marginBottom: '1rem'
  };

  const filterButtonStyles = (active: boolean): React.CSSProperties => ({
    padding: '0.5rem 1rem',
    border: `1px solid ${active ? appliedTheme.accentColor : '#e5e7eb'}`,
    backgroundColor: active ? appliedTheme.accentColor : 'transparent',
    color: active ? '#ffffff' : appliedTheme.textSecondary,
    borderRadius: '0.375rem',
    cursor: 'pointer',
    fontSize: '0.875rem',
    fontWeight: 500,
    transition: 'all 0.2s'
  });

  return (
    <div style={containerStyles}>
      <div style={headerStyles}>
        <h1 style={titleStyles}>Dashboard</h1>
        <p style={subtitleStyles}>Welcome back! Here's your overview.</p>
      </div>

      <div style={gridStyles}>
        <div style={cardStyles}>
          <div style={cardTitleStyles}>Total Revenue</div>
          <div style={cardValueStyles}>$45,231</div>
          <div style={cardChangeStyles}>+12.5% from last month</div>
        </div>

        <div style={cardStyles}>
          <div style={cardTitleStyles}>Active Users</div>
          <div style={cardValueStyles}>2,345</div>
          <div style={cardChangeStyles}>+8.2% from last month</div>
        </div>

        <div style={cardStyles}>
          <div style={cardTitleStyles}>Conversion Rate</div>
          <div style={cardValueStyles}>3.24%</div>
          <div style={cardChangeStyles}>+0.8% from last month</div>
        </div>

        <div style={cardStyles}>
          <div style={cardTitleStyles}>Avg. Order Value</div>
          <div style={cardValueStyles}>$89.50</div>
          <div style={cardChangeStyles}>+5.3% from last month</div>
        </div>
      </div>

      <div style={chartCardStyles}>
        <div style={cardTitleStyles}>Revenue Trend</div>
        <div style={filterStyles}>
          {['day', 'week', 'month', 'year'].map((tf) => (
            <button
              key={tf}
              style={filterButtonStyles(timeframe === tf)}
              onClick={() => setTimeframe(tf)}
            >
              {tf.charAt(0).toUpperCase() + tf.slice(1)}
            </button>
          ))}
        </div>
        <div style={{ height: '300px', display: 'flex', alignItems: 'center', justifyContent: 'center', color: appliedTheme.textSecondary }}>
          Chart placeholder
        </div>
      </div>
    </div>
  );
};
