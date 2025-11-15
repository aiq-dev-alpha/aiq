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
  const primary = theme.primary || '#ec4899';
  
  const positions = {
    top: { bottom: '100%', left: '50%', transform: 'translateX(-50%)', marginBottom: '29px' },
    bottom: { top: '100%', left: '50%', transform: 'translateX(-50%)', marginTop: '15px' },
    left: { right: '100%', top: '50%', transform: 'translateY(-50%)', marginRight: '15px' },
    right: { left: '100%', top: '50%', transform: 'translateY(-50%)', marginLeft: '15px' }
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
            border: `2px solid #ec4899`,
            borderRadius: '35px',
            padding: '22px 29px',
            boxShadow: '0 11px 21px rgba(0,0,0,0.18)',
            zIndex: 1000,
            minWidth: '180px',
            maxWidth: '350px',
            fontSize: '19px',
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