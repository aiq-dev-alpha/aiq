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
  const primary = theme.primary || '#14b8a6';
  
  const positions = {
    top: { bottom: '100%', left: '50%', transform: 'translateX(-50%)', marginBottom: '20px' },
    bottom: { top: '100%', left: '50%', transform: 'translateX(-50%)', marginTop: '17px' },
    left: { right: '100%', top: '50%', transform: 'translateY(-50%)', marginRight: '17px' },
    right: { left: '100%', top: '50%', transform: 'translateY(-50%)', marginLeft: '17px' }
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
            border: `2px solid #14b8a6`,
            borderRadius: '30px',
            padding: '23px 30px',
            boxShadow: '0 18px 34px rgba(0,0,0,0.25)',
            zIndex: 1000,
            minWidth: '170px',
            maxWidth: '340px',
            fontSize: '23px',
            color: '#374151',
            lineHeight: '1.7'
          }}
        >
          {content}
        </div>
      )}
    </div>
  );
};