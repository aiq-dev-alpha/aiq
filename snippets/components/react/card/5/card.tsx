import React from 'react';

export type CardVariant = 'standard' | 'outlined' | 'filled' | 'glass' | 'gradient';
export type CardPadding = 'none' | 'tight' | 'normal' | 'loose' | 'spacious';

interface CardConfig {
  palette: {
    background: string;
    text: string;
    accent: string;
    border: string;
  };
  geometry: {
    borderRadius: string;
    borderWidth: string;
  };
  effects: {
    shadow: string;
    blur: string;
  };
}

interface CardProps {
  children: React.ReactNode;
  variant?: CardVariant;
  padding?: CardPadding;
  hoverable?: boolean;
  titleSlot?: React.ReactNode;
  actionsSlot?: React.ReactNode;
  config?: Partial<CardConfig>;
  styleOverrides?: React.CSSProperties;
  onInteract?: () => void;
}

const defaultConfig: CardConfig = {
  palette: {
    background: '#ffffff',
    text: '#1e293b',
    accent: '#3b82f6',
    border: '#cbd5e1'
  },
  geometry: {
    borderRadius: '1rem',
    borderWidth: '1px'
  },
  effects: {
    shadow: '0 2px 8px rgba(0, 0, 0, 0.08)',
    blur: 'blur(12px)'
  }
};

export const Card: React.FC<CardProps> = ({
  children,
  variant = 'standard',
  padding = 'normal',
  hoverable = false,
  titleSlot,
  actionsSlot,
  config = {},
  styleOverrides = {},
  onInteract
}) => {
  const cfg = { ...defaultConfig, ...config };

  const paddingMap: Record<CardPadding, string> = {
    none: '0',
    tight: '0.75rem',
    normal: '1.5rem',
    loose: '2rem',
    spacious: '2.5rem'
  };

  const variantStyles: Record<CardVariant, React.CSSProperties> = {
    standard: {
      backgroundColor: cfg.palette.background,
      border: 'none',
      boxShadow: cfg.effects.shadow
    },
    outlined: {
      backgroundColor: cfg.palette.background,
      border: `${cfg.geometry.borderWidth} solid ${cfg.palette.border}`,
      boxShadow: 'none'
    },
    filled: {
      backgroundColor: `${cfg.palette.accent}15`,
      border: 'none',
      boxShadow: 'none'
    },
    glass: {
      backgroundColor: `${cfg.palette.background}80`,
      border: `${cfg.geometry.borderWidth} solid ${cfg.palette.border}40`,
      boxShadow: '0 8px 32px rgba(0, 0, 0, 0.1)',
      backdropFilter: cfg.effects.blur
    },
    gradient: {
      background: `linear-gradient(135deg, ${cfg.palette.background}, ${cfg.palette.accent}20)`,
      border: 'none',
      boxShadow: cfg.effects.shadow
    }
  };

  const baseStyles: React.CSSProperties = {
    color: cfg.palette.text,
    borderRadius: cfg.geometry.borderRadius,
    overflow: 'hidden',
    transition: hoverable ? 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)' : 'none',
    cursor: hoverable ? 'pointer' : 'default',
    fontFamily: 'system-ui, sans-serif',
    ...variantStyles[variant],
    ...styleOverrides
  };

  const titleStyles: React.CSSProperties = {
    padding: paddingMap[padding],
    borderBottom: `${cfg.geometry.borderWidth} solid ${cfg.palette.border}`,
    fontWeight: 600,
    fontSize: '1.125rem',
    color: cfg.palette.text
  };

  const contentStyles: React.CSSProperties = {
    padding: paddingMap[padding]
  };

  const actionsStyles: React.CSSProperties = {
    padding: `${paddingMap[padding]}`,
    borderTop: `${cfg.geometry.borderWidth} solid ${cfg.palette.border}`,
    display: 'flex',
    gap: '0.75rem',
    justifyContent: 'flex-end'
  };

  return (
    <div
      style={baseStyles}
      onClick={onInteract}
      onMouseEnter={(e) => {
        if (hoverable) {
          e.currentTarget.style.transform = 'scale(1.02)';
          e.currentTarget.style.boxShadow = '0 8px 24px rgba(0, 0, 0, 0.15)';
        }
      }}
      onMouseLeave={(e) => {
        if (hoverable) {
          e.currentTarget.style.transform = 'scale(1)';
          e.currentTarget.style.boxShadow = cfg.effects.shadow;
        }
      }}
    >
      {titleSlot && <div style={titleStyles}>{titleSlot}</div>}
      <div style={contentStyles}>{children}</div>
      {actionsSlot && <div style={actionsStyles}>{actionsSlot}</div>}
    </div>
  );
};
