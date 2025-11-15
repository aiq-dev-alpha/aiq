import React from 'react';
interface SpinnerProps {
  size?: 'sm' | 'md' | 'lg';
  color?: string;
  variant?: 'circle' | 'dots' | 'bars';
}
export const Spinner: React.FC<SpinnerProps> = ({
  size = 'md',
  color = 'blue-600',
  variant = 'circle'
}) => {
  const sizes = {
    sm: 'w-4 h-4',
    md: 'w-8 h-8',
    lg: 'w-12 h-12'
  };
  if (variant === 'circle') {
    return (
      <svg className={`${sizes[size]} animate-spin text-${color}`} viewBox="0 0 24 24" fill="none">
        <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" />
        <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" />
      </svg>
    );
  }
  if (variant === 'dots') {
    return (
      <div className="flex gap-1">
        {[0, 1, 2].map(i => (
          <div
            key={i}
            className={`w-2 h-2 bg-${color} rounded-full animate-bounce`}
            style={{ animationDelay: `${i * 0.15}s` }}
          />
        ))}
      </div>
    );
  }
  return (
    <div className="flex gap-1">
      {[0, 1, 2, 3].map(i => (
        <div
          key={i}
          className={`w-1 h-8 bg-${color} rounded animate-pulse`}
          style={{ animationDelay: `${i * 0.1}s` }}
        />
      ))}
    </div>
  );
};
