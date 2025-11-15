import React, { useState, useEffect } from 'react';

export interface ButtonProps {
  theme?: {
    primary?: string;
    background?: string;
    text?: string;
  };
  className?: string;
  onHover?: (isHovered: boolean) => void;
}

export const Button: React.FC<ButtonProps> = ({
  theme = {},
  className = '',
  onHover
}) => {
  const [isVisible, setIsVisible] = useState(false);
  const [isHovered, setIsHovered] = useState(false);
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const handleMouseEnter = () => {
    setIsHovered(true);
    onHover?.(true);
  };

  const handleMouseLeave = () => {
    setIsHovered(false);
    onHover?.(false);
  };

  const containerStyles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transition: 'all 300ms ease',
    display: 'inline-flex',
    position: 'relative',
  };

  const mainButtonStyles: React.CSSProperties = {
    padding: '12px 20px',
    backgroundColor: theme.primary || '#3b82f6',
    color: '#ffffff',
    borderRadius: '8px 0 0 8px',
    border: 'none',
    cursor: 'pointer',
    fontWeight: 600,
  };

  const dropdownButtonStyles: React.CSSProperties = {
    padding: '12px 16px',
    backgroundColor: theme.primary || '#3b82f6',
    color: '#ffffff',
    borderRadius: '0 8px 8px 0',
    border: 'none',
    borderLeft: '1px solid rgba(255, 255, 255, 0.3)',
    cursor: 'pointer',
    fontWeight: 600,
  };

  const dropdownStyles: React.CSSProperties = {
    position: 'absolute',
    top: '100%',
    right: 0,
    marginTop: '4px',
    backgroundColor: '#ffffff',
    borderRadius: '8px',
    boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)',
    padding: '8px',
    minWidth: '150px',
    opacity: isOpen ? 1 : 0,
    transform: isOpen ? 'translateY(0)' : 'translateY(-10px)',
    visibility: isOpen ? 'visible' : 'hidden',
    transition: 'all 200ms ease',
  };

  return (
    <div className={className} style={containerStyles}>
      <button
        style={mainButtonStyles}
        onMouseEnter={handleMouseEnter}
        onMouseLeave={handleMouseLeave}
      >
        Split Button
      </button>
      <button
        style={dropdownButtonStyles}
        onClick={() => setIsOpen(!isOpen)}
      >
        ▼
      </button>
      <div style={dropdownStyles}>
        <div style={{ padding: '8px', cursor: 'pointer' }}>Option 1</div>
        <div style={{ padding: '8px', cursor: 'pointer' }}>Option 2</div>
      </div>
    </div>
  );
};
