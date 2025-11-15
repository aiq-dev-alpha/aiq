import React, { useState, CSSProperties, ReactNode } from 'react';

interface NavTheme {
  background: string;
  text: string;
  accent: string;
  border: string;
  hover: string;
}

interface NavItem {
  label: string;
  href?: string;
  icon?: ReactNode;
  badge?: string | number;
  active?: boolean;
  onClick?: () => void;
}

interface NavbarProps {
  logo?: ReactNode;
  brandText?: string;
  items?: NavItem[];
  actions?: ReactNode;
  variant?: 'solid' | 'transparent' | 'blur' | 'gradient';
  position?: 'fixed' | 'sticky' | 'static';
  theme?: Partial<NavTheme>;
  mobileBreakpoint?: number;
  onBrandClick?: () => void;
}

const defaultTheme: NavTheme = {
  background: '#0f172a',
  text: '#f8fafc',
  accent: '#06b6d4',
  border: '#1e293b',
  hover: '#1e293b'
};

export const Navbar: React.FC<NavbarProps> = ({
  logo,
  brandText,
  items = [],
  actions,
  variant = 'solid',
  position = 'static',
  theme = {},
  mobileBreakpoint = 768,
  onBrandClick
}) => {
  const [isMobileOpen, setIsMobileOpen] = useState(false);
  const appliedTheme = { ...defaultTheme, ...theme };

  const variantStyles: Record<string, CSSProperties> = {
    solid: {
      background: appliedTheme.background,
      borderBottom: `2px solid ${appliedTheme.border}`,
      backdropFilter: 'none',
      boxShadow: '0 2px 8px rgba(0, 0, 0, 0.1)'
    },
    transparent: {
      background: 'transparent',
      borderBottom: 'none',
      backdropFilter: 'none',
      boxShadow: 'none'
    },
    blur: {
      background: `${appliedTheme.background}f0`,
      borderBottom: `1px solid ${appliedTheme.border}90`,
      backdropFilter: 'blur(16px) saturate(180%)',
      boxShadow: '0 1px 3px rgba(0, 0, 0, 0.1)'
    },
    gradient: {
      background: `linear-gradient(135deg, ${appliedTheme.background}, ${appliedTheme.accent}20)`,
      borderBottom: `1px solid ${appliedTheme.accent}40`,
      backdropFilter: 'none',
      boxShadow: '0 4px 12px rgba(6, 182, 212, 0.15)'
    }
  };

  const navStyle: CSSProperties = {
    ...variantStyles[variant],
    position: position as any,
    top: position !== 'static' ? 0 : undefined,
    left: 0,
    right: 0,
    zIndex: 1000,
    color: appliedTheme.text,
    fontFamily: 'system-ui, -apple-system, sans-serif'
  };

  const containerStyle: CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: '16px 24px',
    maxWidth: '1280px',
    margin: '0 auto',
    gap: '24px'
  };

  const brandStyle: CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '12px',
    cursor: 'pointer',
    fontSize: '18px',
    fontWeight: 700
  };

  const menuStyle: CSSProperties = {
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    flex: 1
  };

  const itemStyle = (item: NavItem): CSSProperties => ({
    display: 'flex',
    alignItems: 'center',
    gap: '7px',
    padding: '10px 18px',
    borderRadius: '10px',
    cursor: 'pointer',
    transition: 'all 0.25s cubic-bezier(0.4, 0, 0.2, 1)',
    background: item.active ? `${appliedTheme.accent}25` : 'transparent',
    color: item.active ? appliedTheme.accent : appliedTheme.text,
    fontWeight: item.active ? 700 : 500,
    fontSize: '14px',
    position: 'relative',
    textDecoration: 'none',
    letterSpacing: '0.3px',
    border: item.active ? `1px solid ${appliedTheme.accent}40` : '1px solid transparent',
    boxShadow: item.active ? `0 2px 8px ${appliedTheme.accent}30` : 'none'
  });

  const badgeStyle: CSSProperties = {
    position: 'absolute',
    top: '2px',
    right: '2px',
    background: `linear-gradient(135deg, ${appliedTheme.accent}, ${appliedTheme.accent}cc)`,
    color: '#fff',
    borderRadius: '12px',
    padding: '3px 7px',
    fontSize: '10px',
    fontWeight: 800,
    minWidth: '20px',
    textAlign: 'center',
    boxShadow: `0 2px 6px ${appliedTheme.accent}60`,
    letterSpacing: '0.2px'
  };

  const toggleStyle: CSSProperties = {
    display: 'none',
    background: 'none',
    border: 'none',
    fontSize: '24px',
    cursor: 'pointer',
    padding: '8px',
    color: appliedTheme.text
  };

  return (
    <>
      <style>{`
        @media (max-width: ${mobileBreakpoint}px) {
          .nav-toggle { display: block !important; }
          .nav-menu {
            position: fixed;
            top: 60px;
            left: 0;
            right: 0;
            background: ${appliedTheme.background};
            flex-direction: column;
            padding: 16px;
            display: ${isMobileOpen ? 'flex' : 'none'};
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
          }
        }
      `}</style>
      <nav style={navStyle}>
        <div style={containerStyle}>
          <div style={brandStyle} onClick={onBrandClick}>
            {logo}
            {brandText && <span>{brandText}</span>}
          </div>

          <button
            className="nav-toggle"
            style={toggleStyle}
            onClick={() => setIsMobileOpen(!isMobileOpen)}>
            {isMobileOpen ? '✕' : '☰'}
          </button>

          <div className="nav-menu" style={menuStyle}>
            {items.map((item, idx) => (
              <div
                key={idx}
                style={itemStyle(item)}
                onClick={item.onClick}
                onMouseEnter={(e) => {
                  if (!item.active) {
                    e.currentTarget.style.background = appliedTheme.hover;
                  }
                }}
                onMouseLeave={(e) => {
                  if (!item.active) {
                    e.currentTarget.style.background = 'transparent';
                  }
                }}>
                {item.icon}
                <span>{item.label}</span>
                {item.badge && <span style={badgeStyle}>{item.badge}</span>}
              </div>
            ))}
          </div>

          {actions && <div style={{ display: 'flex', gap: '12px', alignItems: 'center' }}>{actions}</div>}
        </div>
      </nav>
    </>
  );
};
