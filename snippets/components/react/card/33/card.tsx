import React from 'react';

// Card Variant 33: Lime Light

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
  background: 'linear-gradient(135deg, #99f2c8 0%, #1f4037 100%)',
  foreground: '#ffffff',
  border: '#66bb6a',
  accent: '#81c784',
  shadow: 'rgba(153, 242, 200, 0.35)'
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
    borderRadius: '24px',
    overflow: 'hidden',
    transition: 'all 0.35s ease-in-out',
    cursor: clickable || onClick ? 'pointer' : 'default',
    position: 'relative',
    maxWidth: '400px',
    fontFamily: 'system-ui, -apple-system, sans-serif'
  };

  const variantStyles: Record<string, React.CSSProperties> = {
    default: {
      boxShadow: `0 4px 16px ${finalTheme.shadow}`
    },
    elevated: {
      boxShadow: `0 10px 30px ${finalTheme.shadow}, 0 4px 16px ${finalTheme.shadow}`
    },
    outlined: {
      background: 'transparent',
      border: `2px solid ${finalTheme.border}`,
      color: finalTheme.border
    },
    gradient: {
      boxShadow: `0 8px 28px ${finalTheme.shadow}`
    },
    glass: {
      background: `${finalTheme.background}25`,
      backdropFilter: 'blur(14px)',
      border: `1px solid ${finalTheme.accent}50`
    },
    neumorphic: {
      background: '#f0e6e6',
      color: '#2d1f1f',
      boxShadow: `9px 9px 18px ${finalTheme.shadow}, -9px -9px 18px rgba(255, 255, 255, 0.75)`
    }
  };

  const hoverStyle: React.CSSProperties = hoverable ? {
    transform: 'translateY(-6px) scale(1.01)',
    boxShadow: `0 24px 48px ${finalTheme.shadow}`
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
        <div style={{ position: 'relative', width: '100%', height: '210px', overflow: 'hidden' }}>
          <img
            src={image}
            alt={imageAlt}
            style={{
              width: '100%',
              height: '100%',
              objectFit: 'cover',
              transition: 'transform 0.5s ease',
              transform: isHovered ? 'scale(1.08)' : 'scale(1)'
            }}
          />
          <div style={{
            position: 'absolute',
            bottom: 0,
            left: 0,
            right: 0,
            height: '40%',
            background: 'linear-gradient(to bottom, transparent, rgba(0,0,0,0.3))'
          }} />
        </div>
      ))}

      <div style={{ padding: '26px' }}>
        {(title || subtitle) && (
          <div style={{ marginBottom: '18px' }}>
            {title && (
              <h3 style={{
                margin: '0 0 8px 0',
                fontSize: '25px',
                fontWeight: '800',
                color: variant === 'neumorphic' ? '#2d1f1f' : finalTheme.foreground
              }}>
                {title}
              </h3>
            ))}
            {subtitle && (
              <p style={{
                margin: 0,
                fontSize: '14px',
                color: variant === 'neumorphic' ? '#5a4a4a' : finalTheme.foreground,
                opacity: 0.8
              }}>
                {subtitle}
              </p>
            ))}
          </div>
        ))}

        <div style={{ marginBottom: actions ? '22px' : 0 }}>
          {description && (
            <p style={{
              margin: '0 0 16px 0',
              fontSize: '16px',
              lineHeight: '1.6',
              color: variant === 'neumorphic' ? '#5a4a4a' : finalTheme.foreground,
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
            borderTop: `1px solid ${variant === 'neumorphic' ? '#d9c9c9' : finalTheme.accent}50`
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
                  borderRadius: '16px',
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
