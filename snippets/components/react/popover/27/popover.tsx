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
  position = 'top'
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const primary = theme.primary || '#2563eb';
  
  const positions = {
    top: { bottom: '100%', left: '50%', transform: 'translateX(-50%)', marginBottom: '10px' },
    bottom: { top: '100%', left: '50%', transform: 'translateX(-50%)', marginTop: '16px' },
    left: { right: '100%', top: '50%', transform: 'translateY(-50%)', marginRight: '16px' },
    right: { left: '100%', top: '50%', transform: 'translateY(-50%)', marginLeft: '16px' }
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
            border: `2px solid #2563eb`,
            borderRadius: '22px',
            padding: '22px 30px',
            boxShadow: '0 16px 30px rgba(0,0,0,0.22)',
            zIndex: 1000,
            minWidth: '180px',
            maxWidth: '350px',
            fontSize: '18px',
            color: '#374151',
            lineHeight: '1.6'
          }}
        >
          {content}
        </div>
      )}
    </div>
  );
};