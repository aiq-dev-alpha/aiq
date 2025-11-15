import React from 'react';
interface BadgeProps {
  count: number;
  max?: number;
  showZero?: boolean;
  variant?: 'primary' | 'secondary' | 'danger';
  onDismiss?: () => void;
}
export const Badge: React.FC<BadgeProps> = ({
  count,
  max = 99,
  showZero = false,
  variant = 'danger',
  onDismiss
}) => {
  if (count === 0 && !showZero) return null;
  const displayCount = count > max ? `${max}+` : count;
  const variants = {
    primary: 'bg-blue-600 text-white',
    secondary: 'bg-gray-600 text-white',
    danger: 'bg-red-600 text-white'
  };
  return (
    <span className={`inline-flex items-center gap-1 ${variants[variant]} px-2 py-0.5 rounded-full text-xs font-semibold shadow-md animate-bounce`} style={{ animationDuration: '1s', animationIterationCount: 3 }}>
      {displayCount}
      {onDismiss && (
        <button onClick={onDismiss} className="ml-0.5 hover:opacity-70 focus:outline-none">
          <svg className="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
            <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
          </svg>
        </button>
      )}
    </span>
  );
};
