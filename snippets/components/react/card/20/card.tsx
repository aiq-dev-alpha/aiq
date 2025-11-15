// Variant 20: Notification card with dismiss button
import React, { useState, useEffect } from 'react';

export interface CardProps {
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Card: React.FC<CardProps> = ({ theme = {}, className = '', onHover }) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [isDismissed, setIsDismissed] = useState(false);

  useEffect(() => { setIsVisible(true); }, []);

  if (isDismissed) {
    return null;
  }

  return (
    <div
      className={className}
      style={{
        opacity: isVisible ? 1 : 0,
        transform: isVisible ? 'translateX(0)' : 'translateX(100px)',
        transition: 'all 300ms cubic-bezier(0.4, 0, 0.2, 1)',
        display: 'flex',
        alignItems: 'flex-start',
        gap: '16px',
        padding: '20px',
        backgroundColor: theme.background || '#ffffff',
        borderRadius: '12px',
        borderLeft: `4px solid ${theme.primary || '#3b82f6'}`,
        boxShadow: isHovered ? '0 8px 20px rgba(0,0,0,0.12)' : '0 4px 12px rgba(0,0,0,0.08)',
        cursor: 'pointer',
        width: '380px',
      }}
      onMouseEnter={() => { setIsHovered(true); onHover?.(true); }}
      onMouseLeave={() => { setIsHovered(false); onHover?.(false); }}
    >
      <div style={{
        width: '48px',
        height: '48px',
        borderRadius: '12px',
        background: `linear-gradient(135deg, ${theme.primary || '#3b82f6'}, ${theme.primary || '#3b82f6'}dd)`,
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        fontSize: '24px',
        flexShrink: 0,
      }}>
        🔔
      </div>
      <div style={{ flex: 1 }}>
        <h4 style={{ fontSize: '16px', fontWeight: 'bold', color: theme.text || '#111827', marginBottom: '6px' }}>
          New message received
        </h4>
        <p style={{ fontSize: '14px', color: '#6b7280', lineHeight: '1.5', marginBottom: '12px' }}>
          You have a new message from the support team regarding your recent inquiry.
        </p>
        <div style={{ fontSize: '12px', color: '#9ca3af' }}>2 minutes ago</div>
        <div style={{ display: 'flex', gap: '8px', marginTop: '12px' }}>
          <button style={{
            padding: '8px 16px',
            borderRadius: '6px',
            border: 'none',
            backgroundColor: theme.primary || '#3b82f6',
            color: '#ffffff',
            fontSize: '13px',
            fontWeight: '600',
            cursor: 'pointer',
          }}>
            View
          </button>
          <button style={{
            padding: '8px 16px',
            borderRadius: '6px',
            border: '1px solid #e5e7eb',
            backgroundColor: 'transparent',
            color: theme.text || '#111827',
            fontSize: '13px',
            fontWeight: '600',
            cursor: 'pointer',
          }}>
            Mark as Read
          </button>
        </div>
      </div>
      <button
        onClick={(e) => { e.stopPropagation(); setIsDismissed(true); }}
        style={{
          width: '28px',
          height: '28px',
          borderRadius: '6px',
          border: 'none',
          backgroundColor: '#f3f4f6',
          color: '#6b7280',
          fontSize: '16px',
          cursor: 'pointer',
          flexShrink: 0,
        }}
      >
        ✕
      </button>
    </div>
  );
};
