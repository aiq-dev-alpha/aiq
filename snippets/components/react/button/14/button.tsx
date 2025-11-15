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
  const [selected, setSelected] = useState(0);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const buttonStyle = (index: number): React.CSSProperties => ({
    padding: '10px 20px',
    backgroundColor: selected === index ? (theme.primary || '#3b82f6') : '#ffffff',
    color: selected === index ? '#ffffff' : (theme.text || '#111827'),
    border: \`1px solid \${theme.primary || '#3b82f6'}\`,
    borderRadius: index === 0 ? '8px 0 0 8px' : index === 2 ? '0 8px 8px 0' : '0',
    borderLeft: index === 0 ? \`1px solid \${theme.primary || '#3b82f6'}\` : 'none',
    cursor: 'pointer',
    fontWeight: 600,
    transition: 'all 200ms ease',
  });

  const containerStyle: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transition: 'all 300ms ease',
    display: 'inline-flex',
  };

  return (
    <div className={className} style={containerStyle}>
      <button style={buttonStyle(0)} onClick={() => setSelected(0)}>Left</button>
      <button style={buttonStyle(1)} onClick={() => setSelected(1)}>Center</button>
      <button style={buttonStyle(2)} onClick={() => setSelected(2)}>Right</button>
    </div>
  );
};