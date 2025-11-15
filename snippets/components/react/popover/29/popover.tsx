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
  position = 'left'
}) => {
  const [isOpen, setIsOpen] = useState(false);
  const primary = theme.primary || '#ef4444';
  
  const positions = {
    top: { bottom: '100%', left: '50%', transform: 'translateX(-50%)', marginBottom: '15px' },
    bottom: { top: '100%', left: '50%', transform: 'translateX(-50%)', marginTop: '13px' },
    left: { right: '100%', top: '50%', transform: 'translateY(-50%)', marginRight: '13px' },
    right: { left: '100%', top: '50%', transform: 'translateY(-50%)', marginLeft: '13px' }
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
            border: `2px solid #e5e7eb`,
            borderRadius: '21px',
            padding: '22px 31px',
            boxShadow: '0 7px 17px rgba(0,0,0,0.18)',
            zIndex: 1000,
            minWidth: '200px',
            maxWidth: '320px',
            fontSize: '15px',
            color: '#374151',
            lineHeight: '1.4'
          }}
        >
          {content}
        </div>
      )}
    </div>
  );
};