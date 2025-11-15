import React from 'react';

// Card Variant 2: Ocean Wave

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
  background: 'linear-gradient(135deg, #667eea 0%, #764ba2 50%, #f093fb 100%)',
  foreground: '#ffffff',
  border: '#764ba2',
  accent: '#a78bfa',
  shadow: 'rgba(102, 126, 234, 0.4)'
};

export const Card: React.FC<CardProps> = ({
  variant = 'gradient',
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
    borderRadius: '20px',
    overflow: 'hidden',
    transition: 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)',
    cursor: clickable || onClick ? 'pointer' : 'default',
    position: 'relative',
    maxWidth: '400px',
    fontFamily: 'system-ui, -apple-system, sans-serif'
  };

  const variantStyles: Record<string, React.CSSProperties> = {
    default: {
      boxShadow: `0 4px 12px ${finalTheme.shadow}`
    },
    elevated: {
      boxShadow: `0 12px 32px ${finalTheme.shadow}, 0 4px 12px ${finalTheme.shadow}`
    },
    outlined: {
      background: 'transparent',
      border: `2px solid ${finalTheme.border}`,
      color: finalTheme.border
    },
    gradient: {
      boxShadow: `0 8px 24px ${finalTheme.shadow}`
    },
    glass: {
      background: `${finalTheme.background}25`,
      backdropFilter: 'blur(14px)',
      border: `1px solid ${finalTheme.accent}50`
    },
    neumorphic: {
      background: '#e0e5ec',
      color: '#333333',
      boxShadow: `9px 9px 18px ${finalTheme.shadow}, -9px -9px 18px rgba(255, 255, 255, 0.75)`
    }
  };

  const hoverStyle: React.CSSProperties = hoverable ? {
    transform: 'scale(1.02) translateY(-4px)',
    boxShadow: `0 20px 40px ${finalTheme.shadow}`
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
        <div style={{ position: 'relative', width: '100%', height: '220px', overflow: 'hidden' }}>
          <img
            src={image}
            alt={imageAlt}
            style={{
              width: '100%',
              height: '100%',
              objectFit: 'cover',
              transition: 'transform 0.4s ease',
              transform: isHovered ? 'scale(1.1) rotate(2deg)' : 'scale(1)'
            }}
          />
          <div style={{
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            height: '100%',
            background: 'linear-gradient(135deg, rgba(100,100,100,0.2), transparent)'
          }} />
        </div>
      ))}

      <div style={{ padding: '28px' }}>
        {(title || subtitle) && (
          <div style={{ marginBottom: '20px' }}>
            {title && (
              <h3 style={{
                margin: '0 0 10px 0',
                fontSize: '26px',
                fontWeight: '800',
                color: variant === 'neumorphic' ? '#333333' : finalTheme.foreground
              }}>
                {title}
              </h3>
            ))}
            {subtitle && (
              <p style={{
                margin: 0,
                fontSize: '15px',
                color: variant === 'neumorphic' ? '#666666' : finalTheme.foreground,
                opacity: 0.8
              }}>
                {subtitle}
              </p>
            ))}
          </div>
        ))}

        <div style={{ marginBottom: actions ? '24px' : 0 }}>
          {description && (
            <p style={{
              margin: '0 0 16px 0',
              fontSize: '16px',
              lineHeight: '1.6',
              color: variant === 'neumorphic' ? '#666666' : finalTheme.foreground,
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
            borderTop: `1px solid ${variant === 'neumorphic' ? '#cccccc' : finalTheme.accent}50`
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
                  borderRadius: '12px',
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
