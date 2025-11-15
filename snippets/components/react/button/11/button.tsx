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
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    setIsVisible(true);
  }, []);

  const handleClick = () => {
    setIsLoading(true);
    setTimeout(() => setIsLoading(false), 2000);
  };

  const styles: React.CSSProperties = {
    opacity: isVisible ? 1 : 0,
    transition: 'all 300ms ease',
    padding: '12px 24px',
    backgroundColor: isLoading ? '#9ca3af' : (theme.primary || '#3b82f6'),
    color: '#ffffff',
    borderRadius: '8px',
    border: 'none',
    cursor: isLoading ? 'wait' : 'pointer',
    fontWeight: 600,
    display: 'flex',
    alignItems: 'center',
    gap: '8px',
    pointerEvents: isLoading ? 'none' : 'auto',
  };

  return (
    <div className={className} style={styles} onClick={handleClick}>
      {isLoading && <span style={{ animation: 'spin 1s linear infinite' }}>⟳</span>}
      {isLoading ? 'Loading...' : 'Loading Button'}
      <style>
        {\`
          @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
          }
        \`}
      </style>
    </div>
  );
};