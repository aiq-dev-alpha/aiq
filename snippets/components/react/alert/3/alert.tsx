import React, { useState } from 'react';

interface AlertProps {
  type?: 'info' | 'success' | 'warning' | 'error';
  title?: string;
  message: string;
  dismissible?: boolean;
  onDismiss?: () => void;
  className?: string;
}

export default function Alert({ 
  type = 'info', 
  title, 
  message, 
  dismissible = false, 
  onDismiss,
  className = '' 
}: AlertProps) {
  const [isVisible, setIsVisible] = useState(true);

  const typeConfig = {
    info: { bg: 'bg-blue-50', border: 'border-blue-400', text: 'text-blue-800', icon: 'ℹ️' },
    success: { bg: 'bg-green-50', border: 'border-green-400', text: 'text-green-800', icon: '✓' },
    warning: { bg: 'bg-yellow-50', border: 'border-yellow-400', text: 'text-yellow-800', icon: '⚠' },
    error: { bg: 'bg-red-50', border: 'border-red-400', text: 'text-red-800', icon: '✕' },
  };

  const config = typeConfig[type];

  const handleDismiss = () => {
    setIsVisible(false);
    setTimeout(() => onDismiss?.(), 300);
  };

  if (!isVisible) return null;

  return (
    <div
      className={`${config.bg} ${config.border} border-l-4 p-4 rounded-r-lg shadow-md transition-all duration-300 ${
        isVisible ? 'opacity-100 translate-x-0' : 'opacity-0 -translate-x-full'
      } ${className}`}
    >
      <div className="flex items-start">
        <span className="text-2xl mr-3">{config.icon}</span>
        <div className="flex-1">
          {title && <h3 className={`font-bold ${config.text} mb-1`}>{title}</h3>}
          <p className={config.text}>{message}</p>
        </div>
        {dismissible && (
          <button
            onClick={handleDismiss}
            className={`ml-4 ${config.text} hover:opacity-70 transition-opacity`}
          >
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
            </svg>
          </button>
        )}
      </div>
    </div>
  );
}