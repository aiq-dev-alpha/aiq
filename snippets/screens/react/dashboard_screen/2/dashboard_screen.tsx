import React, { useState } from 'react';

interface Theme {
  primaryColor: string;
  secondaryColor: string;
  surfaceColor: string;
  textColor: string;
  borderColor: string;
}

interface DashboardProps {
  theme?: Partial<Theme>;
  styles?: React.CSSProperties;
}

const defaultTheme: Theme = {
  primaryColor: '#8b5cf6',
  secondaryColor: '#a78bfa',
  surfaceColor: '#1f2937',
  textColor: '#f3f4f6',
  borderColor: '#374151'
};

export const DashboardScreen: React.FC<DashboardProps> = ({
  theme = {},
  styles = {}
}) => {
  const [activeTab, setActiveTab] = useState('overview');
  const appliedTheme = { ...defaultTheme, ...theme };

  const containerStyles: React.CSSProperties = {
    minHeight: '100vh',
    backgroundColor: appliedTheme.surfaceColor,
    color: appliedTheme.textColor,
    fontFamily: 'system-ui, sans-serif',
    ...styles
  };

  const sidebarStyles: React.CSSProperties = {
    width: '250px',
    height: '100vh',
    position: 'fixed',
    left: 0,
    top: 0,
    backgroundColor: '#111827',
    padding: '2rem 1.5rem',
    borderRight: `1px solid ${appliedTheme.borderColor}`
  };

  const mainStyles: React.CSSProperties = {
    marginLeft: '250px',
    padding: '2rem'
  };

  const statsGridStyles: React.CSSProperties = {
    display: 'grid',
    gridTemplateColumns: 'repeat(4, 1fr)',
    gap: '1.5rem',
    marginBottom: '2rem'
  };

  const statCardStyles: React.CSSProperties = {
    background: `linear-gradient(135deg, ${appliedTheme.primaryColor}, ${appliedTheme.secondaryColor})`,
    padding: '1.75rem',
    borderRadius: '1rem',
    boxShadow: '0 10px 20px rgba(0, 0, 0, 0.2)'
  };

  return (
    <div style={containerStyles}>
      <div style={sidebarStyles}>
        <h2 style={{ fontSize: '1.5rem', fontWeight: 700, marginBottom: '2rem', color: appliedTheme.primaryColor }}>Dashboard</h2>
        {['overview', 'analytics', 'reports', 'settings'].map((tab) => (
          <div
            key={tab}
            onClick={() => setActiveTab(tab)}
            style={{
              padding: '0.75rem 1rem',
              borderRadius: '0.5rem',
              cursor: 'pointer',
              marginBottom: '0.5rem',
              backgroundColor: activeTab === tab ? appliedTheme.primaryColor : 'transparent',
              fontWeight: activeTab === tab ? 600 : 400
            }}
          >
            {tab.charAt(0).toUpperCase() + tab.slice(1)}
          </div>
        ))}
      </div>
      <div style={mainStyles}>
        <h1 style={{ fontSize: '2.5rem', fontWeight: 800, marginBottom: '2rem' }}>Overview</h1>
        <div style={statsGridStyles}>
          {[
            { label: 'Revenue', value: '$124.5K', change: '+18%' },
            { label: 'Users', value: '8,492', change: '+12%' },
            { label: 'Orders', value: '1,247', change: '+9%' },
            { label: 'Growth', value: '24.8%', change: '+3%' }
          ].map((stat, idx) => (
            <div key={idx} style={statCardStyles}>
              <div style={{ fontSize: '0.875rem', opacity: 0.9, marginBottom: '0.5rem' }}>{stat.label}</div>
              <div style={{ fontSize: '2rem', fontWeight: 700, marginBottom: '0.25rem' }}>{stat.value}</div>
              <div style={{ fontSize: '0.875rem', color: '#86efac' }}>{stat.change}</div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
