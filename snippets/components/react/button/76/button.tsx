import React, { CSSProperties } from 'react';

interface MotionConfig {
  scale: number;
  duration: string;
  easing: string;
}

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  look?: 'primary' | 'secondary' | 'accent' | 'neutral' | 'danger';
  feel?: 'flat' | 'raised' | 'outlined' | 'tonal' | 'glass';
  compact?: boolean;
  loading?: boolean;
  iconOnly?: boolean;
  startContent?: React.ReactNode;
  endContent?: React.ReactNode;
  motion?: Partial<MotionConfig>;
}

const defaultMotion: MotionConfig = {
  scale: 1.02,
  duration: '0.2s',
  easing: 'ease-out'
};

export const Button: React.FC<ButtonProps> = ({
  children,
  look = 'primary',
  feel = 'flat',
  compact = false,
  loading = false,
  iconOnly = false,
  startContent,
  endContent,
  motion = {},
  disabled,
  ...props
}) => {
  const motionConfig = { ...defaultMotion, ...motion };

  const colorSchemes = {
    primary: { base: '#2563eb', light: '#3b82f6', dark: '#1d4ed8' },
    secondary: { base: '#7c3aed', light: '#8b5cf6', dark: '#6d28d9' },
    accent: { base: '#db2777', light: '#ec4899', dark: '#be185d' },
    neutral: { base: '#6b7280', light: '#9ca3af', dark: '#4b5563' },
    danger: { base: '#dc2626', light: '#ef4444', dark: '#b91c1c' }
  };

  const scheme = colorSchemes[look];

  const feelStyles: Record<string, CSSProperties> = {
    flat: {
      background: `linear-gradient(180deg, ${scheme.light}, ${scheme.base})`,
      color: '#ffffff',
      border: 'none',
      boxShadow: 'none'
    },
    raised: {
      background: `linear-gradient(135deg, ${scheme.base}, ${scheme.dark})`,
      color: '#ffffff',
      border: 'none',
      boxShadow: `0 4px 12px ${scheme.base}40, 0 2px 4px ${scheme.base}30`
    },
    outlined: {
      background: 'transparent',
      color: scheme.base,
      border: `2px solid ${scheme.base}`,
      boxShadow: 'none',
      position: 'relative'
    },
    tonal: {
      background: `linear-gradient(135deg, ${scheme.base}20, ${scheme.base}15)`,
      color: scheme.dark,
      border: `1px solid ${scheme.base}30`,
      boxShadow: 'none'
    },
    glass: {
      background: `linear-gradient(135deg, ${scheme.base}e6, ${scheme.light}cc)`,
      backdropFilter: 'blur(16px) saturate(180%)',
      WebkitBackdropFilter: 'blur(16px) saturate(180%)',
      color: '#ffffff',
      border: `1px solid ${scheme.light}50`,
      boxShadow: `0 8px 24px ${scheme.base}30, inset 0 1px 0 rgba(255,255,255,0.2)`
    }
  };

  const baseStyle: CSSProperties = {
    ...feelStyles[feel],
    padding: compact ? '8px 16px' : iconOnly ? '12px' : '12px 24px',
    fontSize: compact ? '13px' : '14px',
    fontWeight: 600,
    borderRadius: iconOnly ? '50%' : '10px',
    cursor: disabled || loading ? 'not-allowed' : 'pointer',
    opacity: disabled || loading ? 0.5 : 1,
    display: 'inline-flex',
    alignItems: 'center',
    justifyContent: 'center',
    gap: '8px',
    transition: `all ${motionConfig.duration} ${motionConfig.easing}`,
    fontFamily: 'inherit',
    outline: 'none',
    minHeight: compact ? '32px' : '40px',
    minWidth: iconOnly ? (compact ? '32px' : '40px') : 'auto'
  };

  return (
    <button
      style={baseStyle}
      disabled={disabled || loading}
      onMouseEnter={(e) => {
        if (!disabled && !loading) {
          e.currentTarget.style.transform = `scale(${motionConfig.scale})`;
          e.currentTarget.style.filter = 'brightness(1.1)';
          if (feel === 'raised') {
            e.currentTarget.style.boxShadow = `0 6px 20px ${scheme.base}50, 0 3px 8px ${scheme.base}40`;
          }
        }
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.transform = 'scale(1)';
        e.currentTarget.style.filter = 'none';
        if (feel === 'raised') {
          e.currentTarget.style.boxShadow = `0 4px 12px ${scheme.base}40, 0 2px 4px ${scheme.base}30`;
        }
      }}
      {...props}>
      {loading ? (
        <span style={{
          width: '14px',
          height: '14px',
          border: '2px solid currentColor',
          borderTopColor: 'transparent',
          borderRadius: '50%',
          animation: 'btn-spin 0.6s linear infinite'
        }} />
      ) : (
        <>
          {startContent}
          {!iconOnly && children}
          {endContent}
        </>
      )}
      <style>{`@keyframes btn-spin { to { transform: rotate(360deg); } }`}</style>
    </button>
  );
};
