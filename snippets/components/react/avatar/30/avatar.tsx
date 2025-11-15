import React from 'react';

export interface ComponentProps {
  theme?: { primary?: string; background?: string; text?: string; };
  className?: string;
  onInteract?: (type: string) => void;
}

export const Component: React.FC<ComponentProps> = ({ theme = {}, className = '', onInteract }) => {
  const primary = theme.primary || '#0ea5e9';
  const bg = theme.background || '#ffffff';

  return (
    <div
      className={className}
      onClick={() => onInteract?.('click')}
      style={{
        padding: '20px 24px',
        backgroundColor: bg,
        border: `1px solid ${primary}30`,
        borderLeft: `6px solid ${primary}`,
        borderRadius: '32px',
        cursor: 'pointer',
        boxShadow: '0 3px 10px rgba(0,0,0,0.08)',
        transition: 'transform 200ms, box-shadow 200ms'
      }}
      onMouseEnter={e => { e.currentTarget.style.transform = 'translateX(4px)'; e.currentTarget.style.boxShadow = '0 6px 16px rgba(0,0,0,0.12)'; }}
      onMouseLeave={e => { e.currentTarget.style.transform = 'translateX(0)'; e.currentTarget.style.boxShadow = '0 3px 10px rgba(0,0,0,0.08)'; }}
    >
      <div style={{ display: 'flex', alignItems: 'center', gap: '14px' }}>
        <div style={{
          width: '16px',
          height: '16px',
          borderRadius: '50%',
          backgroundColor: primary,
          boxShadow: `0 0 0 4px ${primary}20`
        }} />
        <div>
          <div style={{ fontSize: '16px', fontWeight: 600, color: '#1f2937', marginBottom: '4px' }}>
            Item Title {idx}
          </div>
          <div style={{ fontSize: '13px', color: '#6b7280' }}>
            Description text
          </div>
        </div>
      </div>
    </div>
  );
};
