import React, { useState } from 'react';

export interface ComponentProps {
  name?: string;
  email?: string;
  role?: string;
  theme?: { primary?: string; background?: string; text?: string };
  className?: string;
}

export const Component: React.FC<ComponentProps> = ({
  name = 'John Doe',
  email = 'john@example.com',
  role = 'Developer',
  theme = {},
  className = ''
}) => {
  const [showCard, setShowCard] = useState(false);
  const primary = theme.primary || '#06b6d4';

  return (
    <div
      className={className}
      style={{ position: 'relative', display: 'inline-block' }}
      onMouseEnter={() => setShowCard(true)}
      onMouseLeave={() => setShowCard(false)}
    >
      <div
        style={{
          width: '52px',
          height: '52px',
          borderRadius: '50%',
          backgroundColor: primary,
          color: '#fff',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          fontSize: '18px',
          fontWeight: '600',
          cursor: 'pointer',
          transition: 'transform 0.2s',
          transform: showCard ? 'scale(1.1)' : 'scale(1)'
        }}
      >
        {name.charAt(0).toUpperCase()}
      </div>
      {showCard && (
        <div
          style={{
            position: 'absolute',
            top: '60px',
            left: '50%',
            transform: 'translateX(-50%)',
            backgroundColor: '#fff',
            borderRadius: '12px',
            padding: '16px',
            boxShadow: '0 8px 24px rgba(0,0,0,0.15)',
            minWidth: '200px',
            zIndex: 10
          }}
        >
          <div style={{ fontWeight: '600', fontSize: '16px', marginBottom: '4px' }}>{name}</div>
          <div style={{ fontSize: '14px', color: '#6b7280', marginBottom: '8px' }}>{email}</div>
          <div
            style={{
              fontSize: '12px',
              color: primary,
              backgroundColor: `${primary}20`,
              padding: '4px 8px',
              borderRadius: '6px',
              display: 'inline-block'
            }}
          >
            {role}
          </div>
        </div>
      )}
    </div>
  );
};