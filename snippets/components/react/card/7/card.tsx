import React, { useState } from 'react';

export interface ComponentProps {
  title?: string;
  subtitle?: string;
  content?: React.ReactNode;
  variant?: 'bordered' | 'elevated' | 'gradient';
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  title = 'Card Title',
  subtitle,
  content,
  variant = 'elevated',
  theme = {},
  className = ''
}) => {
  const [expanded, setExpanded] = useState(false);

  const primary = theme.primary || '#8b5cf6';
  const background = theme.background || '#ffffff';
  const text = theme.text || '#1f2937';

  const variantStyles = {
    bordered: {
      border: `2px solid ${primary}`,
      boxShadow: 'none'
    },
    elevated: {
      border: 'none',
      boxShadow: '0 8px 24px rgba(0,0,0,0.12)'
    },
    gradient: {
      border: 'none',
      background: `linear-gradient(135deg, ${primary}15, ${primary}05)`,
      boxShadow: '0 4px 12px rgba(0,0,0,0.08)'
    }
  };

  return (
    <div
      className={className}
      style={{
        backgroundColor: variant !== 'gradient' ? background : undefined,
        background: variant === 'gradient' ? variantStyles.gradient.background : undefined,
        borderRadius: '12px',
        padding: '24px',
        maxWidth: '500px',
        ...variantStyles[variant],
        transition: 'all 200ms'
      }}
    >
      <div style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'flex-start',
        marginBottom: '16px'
      }}>
        <div>
          <h3 style={{
            margin: '0 0 4px 0',
            color: text,
            fontSize: '20px',
            fontWeight: 700
          }}>
            {title}
          </h3>
          {subtitle && (
            <p style={{
              margin: 0,
              color: `${text}80`,
              fontSize: '14px'
            }}>
              {subtitle}
            </p>
          )}
        </div>
        <button
          onClick={() => setExpanded(!expanded)}
          style={{
            background: 'none',
            border: 'none',
            color: primary,
            cursor: 'pointer',
            fontSize: '20px',
            transition: 'transform 200ms',
            transform: expanded ? 'rotate(180deg)' : 'rotate(0)'
          }}
        >
          ▼
        </button>
      </div>
      {expanded && (
        <div style={{
          color: text,
          lineHeight: '1.6',
          animation: 'fadeIn 200ms'
        }}>
          {content || 'Card content goes here with additional details and information.'}
        </div>
      )}
      <style>{`
        @keyframes fadeIn {
          from { opacity: 0; transform: translateY(-8px); }
          to { opacity: 1; transform: translateY(0); }
        }
      `}</style>
    </div>
  );
};