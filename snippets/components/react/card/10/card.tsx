import React from 'react';

// Card Variant 10: Deep Sea

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
  background: 'linear-gradient(135deg, #2e3192 0%, #1bffff 100%)',
  foreground: '#ffffff',
  border: '#4fc3f7',
  accent: '#29b6f6',
  shadow: 'rgba(46, 49, 146, 0.4)'
};

export const Card: React.FC<CardProps> = ({
  variant = 'elevated',
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
    borderRadius: '16px',
    overflow: 'hidden',
    transition: 'all 0.35s ease',
    cursor: clickable || onClick ? 'pointer' : 'default',
    position: 'relative',
    maxWidth: '400px',
    fontFamily: 'system-ui, -apple-system, sans-serif'
  };

  const variantStyles: Record<string, React.CSSProperties> = {
    default: {
      boxShadow: `0 4px 14px ${finalTheme.shadow}`
    },
    elevated: {
      boxShadow: `0 12px 30px ${finalTheme.shadow}, 0 4px 14px ${finalTheme.shadow}`
    },
    outlined: {
      background: 'transparent',
      border: `2px solid ${finalTheme.border}`,
      color: finalTheme.border
    },
    gradient: {
      boxShadow: `0 8px 26px ${finalTheme.shadow}`
    },
    glass: {
      background: `${finalTheme.background}25`,
      backdropFilter: 'blur(14px)',
      border: `1px solid ${finalTheme.accent}50`
    },
    neumorphic: {
      background: '#e3e8f0',
      color: '#1e3c72',
      boxShadow: `9px 9px 18px ${finalTheme.shadow}, -9px -9px 18px rgba(255, 255, 255, 0.75)`
    }
  };

  const hoverStyle: React.CSSProperties = hoverable ? {
    transform: 'translateY(-8px)',
    boxShadow: `0 20px 45px ${finalTheme.shadow}`
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
        <div style={{ position: 'relative', width: '100%', height: '205px', overflow: 'hidden' }}>
          <img
            src={image}
            alt={imageAlt}
            style={{
              width: '100%',
              height: '100%',
              objectFit: 'cover',
              transition: 'transform 0.45s ease',
              transform: isHovered ? 'scale(1.07)' : 'scale(1)'
            }}
          />
          <div style={{
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            height: '100%',
            background: 'linear-gradient(135deg, rgba(100,100,200,0.25), transparent)'
          }} />
        </div>
      ))}

      <div style={{ padding: '25px' }}>
        {(title || subtitle) && (
          <div style={{ marginBottom: '18px' }}>
            {title && (
              <h3 style={{
                margin: '0 0 9px 0',
                fontSize: '25px',
                fontWeight: '750',
                color: variant === 'neumorphic' ? '#1e3c72' : finalTheme.foreground
              }}>
                {title}
              </h3>
            ))}
            {subtitle && (
              <p style={{
                margin: 0,
                fontSize: '14px',
                color: variant === 'neumorphic' ? '#4c6ef5' : finalTheme.foreground,
                opacity: 0.8
              }}>
                {subtitle}
              </p>
            ))}
          </div>
        ))}

        <div style={{ marginBottom: actions ? '21px' : 0 }}>
          {description && (
            <p style={{
              margin: '0 0 16px 0',
              fontSize: '16px',
              lineHeight: '1.6',
              color: variant === 'neumorphic' ? '#4c6ef5' : finalTheme.foreground,
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
            borderTop: `1px solid ${variant === 'neumorphic' ? '#c5d4e8' : finalTheme.accent}50`
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
                  borderRadius: '11px',
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
