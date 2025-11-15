import React, { useState, useEffect } from 'react';

interface AlertProps {
  className?: string;
  message: string;
  type?: 'success' | 'error' | 'warning' | 'info';
  duration?: number;
  onClose?: () => void;
  position?: 'top' | 'bottom';
}

export const Alert: React.FC<AlertProps> = ({
  message,
  type = 'info',
  duration = 5000,
  onClose,
  position = 'top'
}) => {
  const [isVisible, setIsVisible] = useState(true);
  const [isExiting, setIsExiting] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
      setIsExiting(true);
      setTimeout(() => {
        setIsVisible(false);
        onClose?.();
      }, 300);
    }, duration);
    return () => clearTimeout(timer);
  }, [duration, onClose]);

  if (!isVisible) return null;

  const colors = {
    success: { bg: '#10b981', icon: '✓' },
    error: { bg: '#ef4444', icon: '✕' },
    warning: { bg: '#f59e0b', icon: '⚠' },
    info: { bg: '#3b82f6', icon: 'ℹ' }
  };

  return (
    <div
      style={{
        position: 'fixed',
        [position]: 20,
        right: 20,
        background: colors[type].bg,
        color: '#fff',
        padding: '16px 20px',
        borderRadius: '8px',
        boxShadow: '0 10px 25px rgba(0,0,0,0.2)',
        display: 'flex',
        alignItems: 'center',
        gap: '12px',
        minWidth: '300px',
        transform: isExiting ? 'translateX(400px)' : 'translateX(0)',
        opacity: isExiting ? 0 : 1,
        transition: 'all 0.3s ease',
        zIndex: 1000
      }}
    >
      <span style={{ fontSize: '24px', fontWeight: 'bold' }}>{colors[type].icon}</span>
      <span style={{ flex: 1, fontSize: '14px', fontWeight: 500 }}>{message}</span>
      <button
        onClick={() => {
          setIsExiting(true);
          setTimeout(() => {
            setIsVisible(false);
            onClose?.();
          }, 300);
        }}
        style={{
          background: 'rgba(255,255,255,0.2)',
          border: 'none',
          color: '#fff',
          borderRadius: '4px',
          padding: '4px 8px',
          cursor: 'pointer',
          fontSize: '12px'
        }}
      >
        ✕
      </button>
    </div>
  );
};

export default Alert;