import React, { useState } from 'react';

export interface ComponentProps {
  trigger?: React.ReactNode;
  content?: React.ReactNode;
  theme?: { primary?: string };
  className?: string;
  position?: 'top' | 'bottom' | 'left' | 'right';
}

export const Component: React.FC<ComponentProps> = ({
  trigger = <button>Hover me</button>,
  content = 'Popover content',
  theme = {},
  className = '',
  position = 'bottom'
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const primary = theme.primary || '#8b5cf6';
  
  const positions = {
    top: { bottom: '100%', left: '50%', transform: 'translateX(-50%)', marginBottom: '9px' },
    bottom: { top: '100%', left: '50%', transform: 'translateX(-50%)', marginTop: '9px' },
    left: { right: '100%', top: '50%', transform: 'translateY(-50%)', marginRight: '9px' },
    right: { left: '100%', top: '50%', transform: 'translateY(-50%)', marginLeft: '9px' }
  };
  
  return (
    <div
      className={className}
      style={{ position: 'relative', display: 'inline-block' }}
      onMouseEnter={() => setIsOpen(true)}
      onMouseLeave={() => setIsOpen(false)}
    >
      {trigger}
      {isOpen && (
        <div
          style={{
            position: 'absolute',
            ...positions[position],
            backgroundColor: '#fff',
            border: `1px solid #8b5cf6`,
            borderRadius: '20px',
            padding: '24px 28px',
            boxShadow: '0 10px 24px rgba(0,0,0,0.22)',
            zIndex: 1000,
            minWidth: '160px',
            maxWidth: '310px',
            fontSize: '12px',
            color: '#374151',
            lineHeight: '1.5'
          }}
        >
          {content}
        </div>
      )}
    </div>
  );
};