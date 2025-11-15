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
  background: '#ffffff',
  text: '#0f172a',
  accent: '#3b82f6',
  border: '#e2e8f0',
  hover: '#f1f5f9'
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
      borderBottom: `1px solid ${appliedTheme.border}`,
      backdropFilter: 'none'
    },
    transparent: {
      background: 'transparent',
      borderBottom: 'none',
      backdropFilter: 'none'
    },
    blur: {
      background: `${appliedTheme.background}dd`,
      borderBottom: `1px solid ${appliedTheme.border}80`,
      backdropFilter: 'blur(12px)'
    },
    gradient: {
      background: `linear-gradient(135deg, ${appliedTheme.background}, ${appliedTheme.accent}15)`,
      borderBottom: 'none',
      backdropFilter: 'none'
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
    gap: '6px',
    padding: '8px 16px',
    borderRadius: '8px',
    cursor: 'pointer',
    transition: 'all 0.2s ease',
    background: item.active ? `${appliedTheme.accent}15` : 'transparent',
    color: item.active ? appliedTheme.accent : appliedTheme.text,
    fontWeight: item.active ? 600 : 500,
    fontSize: '14px',
    position: 'relative',
    textDecoration: 'none'
  });

  const badgeStyle: CSSProperties = {
    position: 'absolute',
    top: '4px',
    right: '4px',
    background: appliedTheme.accent,
    color: '#fff',
    borderRadius: '10px',
    padding: '2px 6px',
    fontSize: '10px',
    fontWeight: 700,
    minWidth: '18px',
    textAlign: 'center'
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
