import React from 'react';

// Card Variant 44: Pistachio

export interface CardTheme {
  background: string;
  foreground: string;
  border: string;
  accent: string;
  shadow: string;
}

export interface CardAction {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
}

export interface CardProps {
  variant?: 'default' | 'elevated' | 'outlined' | 'gradient' | 'glass' | 'neumorphic';
  title?: string;
  subtitle?: string;
  description?: string;
  image?: string;
  imageAlt?: string;
  hoverable?: boolean;
  clickable?: boolean;
  onClick?: () => void;
  actions?: CardAction[];
  theme?: Partial<CardTheme>;
  children?: React.ReactNode;
}

const defaultTheme: CardTheme = {
  background: 'linear-gradient(135deg, #93c572 0%, #c5e1a5 100%)',
  foreground: '#33691e',
  border: '#689f38',
  accent: '#7cb342',
  shadow: 'rgba(147, 197, 114, 0.3)'
};

export const Card: React.FC<CardProps> = ({
  variant = 'glass',
  title,
  subtitle,
  description,
  image,
  imageAlt = '',
  hoverable = true,
  clickable = false,
  onClick,
  actions,
  theme,
  children
}) => {
  const finalTheme = { ...defaultTheme, ...theme };

  const baseStyle: React.CSSProperties = {
    background: finalTheme.background,
    color: finalTheme.foreground,
    borderRadius: '18px',
    overflow: 'hidden',
    transition: 'all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)',
    cursor: clickable || onClick ? 'pointer' : 'default',
    position: 'relative',
    maxWidth: '400px',
    fontFamily: 'system-ui, -apple-system, sans-serif'
  };

  const variantStyles: Record<string, React.CSSProperties> = {
    default: {
      boxShadow: `0 3px 10px ${finalTheme.shadow}`
    },
    elevated: {
      boxShadow: `0 10px 28px ${finalTheme.shadow}, 0 3px 10px ${finalTheme.shadow}`
    },
    outlined: {
      background: 'transparent',
      border: `2px solid ${finalTheme.border}`,
      color: finalTheme.border
    },
    gradient: {
      boxShadow: `0 6px 20px ${finalTheme.shadow}`
    },
    glass: {
      background: `${finalTheme.background}25`,
      backdropFilter: 'blur(14px)',
      border: `1px solid ${finalTheme.accent}50`
    },
    neumorphic: {
      background: '#e8f5e9',
      color: '#1b5e20',
      boxShadow: `9px 9px 18px ${finalTheme.shadow}, -9px -9px 18px rgba(255, 255, 255, 0.75)`
    }
  };

  const hoverStyle: React.CSSProperties = hoverable ? {
    transform: 'translateY(-10px) scale(1.02)',
    boxShadow: `0 20px 42px ${finalTheme.shadow}`
  } : {};

  const [isHovered, setIsHovered] = React.useState(false);

  return (
    <div
      style={{
        ...baseStyle,
        ...variantStyles[variant],
        ...(isHovered ? hoverStyle : {})
      }}
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
      onClick={onClick}
    >
      {image && (
        <div style={{ position: 'relative', width: '100%', height: '200px', overflow: 'hidden' }}>
          <img
            src={image}
            alt={imageAlt}
            style={{
              width: '100%',
              height: '100%',
              objectFit: 'cover',
              transition: 'transform 0.4s ease',
              transform: isHovered ? 'scale(1.06)' : 'scale(1)'
            }}
          />
          <div style={{
            position: 'absolute',
            bottom: 0,
            left: 0,
            right: 0,
            height: '60%',
            background: 'linear-gradient(to top, rgba(0,0,0,0.6), transparent)'
          }} />
        </div>
      ))}

      <div style={{ padding: '24px' }}>
        {(title || subtitle) && (
          <div style={{ marginBottom: '16px' }}>
            {title && (
              <h3 style={{
                margin: '0 0 8px 0',
                fontSize: '24px',
                fontWeight: '700',
                color: variant === 'neumorphic' ? '#1b5e20' : finalTheme.foreground
              }}>
                {title}
              </h3>
            ))}
            {subtitle && (
              <p style={{
                margin: 0,
                fontSize: '14px',
                color: variant === 'neumorphic' ? '#388e3c' : finalTheme.foreground,
                opacity: 0.8
              }}>
                {subtitle}
              </p>
            ))}
          </div>
        ))}

        <div style={{ marginBottom: actions ? '20px' : 0 }}>
          {description && (
            <p style={{
              margin: '0 0 16px 0',
              fontSize: '16px',
              lineHeight: '1.6',
              color: variant === 'neumorphic' ? '#388e3c' : finalTheme.foreground,
              opacity: 0.9
            }}>
              {description}
            </p>
          ))}
          {children}
        </div>

        {actions && actions.length > 0 && (
          <div style={{
            display: 'flex',
            gap: '12px',
            paddingTop: '16px',
            borderTop: `1px solid ${variant === 'neumorphic' ? '#c8e6c9' : finalTheme.accent}50`
          }}>
            {actions.map((action, index) => (
              <button
                key={index}
                onClick={(e) => {
                  e.stopPropagation();
                  action.onClick();
                }}
                style={{
                  padding: '10px 20px',
                  borderRadius: '10px',
                  border: 'none',
                  fontSize: '14px',
                  fontWeight: '600',
                  cursor: 'pointer',
                  transition: 'all 0.2s ease',
                  background: action.variant === 'primary' ? finalTheme.accent : 'rgba(255,255,255,0.18)',
                  color: '#ffffff',
                  boxShadow: action.variant === 'primary' ? `0 3px 10px ${finalTheme.shadow}` : 'none'
                }}
              >
                {action.label}
              </button>
            ))}
          </div>
        ))}
      </div>
    </div>
  );
};

export default Card;
