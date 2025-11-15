import React from 'react';

interface BadgeProps {
  count?: number;
  max?: number;
  showZero?: boolean;
  dot?: boolean;
  children?: React.ReactNode;
  className?: string;
}

export const Badge: React.FC<BadgeProps> = ({
  count = 0,
  max = 99,
  showZero = false,
  dot = false,
  children,
  className = '',
}) => {
  const displayCount = count > max ? `${max}+` : count;
  const showBadge = count > 0 || showZero;

  if (!children) {
    return showBadge ? (
      <span
        className={`animate-pulse inline-flex items-center justify-center px-2 py-1 text-xs font-bold leading-none text-white bg-orange-500 rounded ${className}`}
      >
        {dot ? null : displayCount}
      </span>
    ) : null;
  }

  return (
    <div className={`animate-pulse relative inline-flex ${className}`}>
      {children}
      {showBadge && (
        <span
          className={`animate-pulse absolute -top-1 -right-1 flex items-center justify-center ${
            dot ? 'w-2 h-2' : 'min-w-[20px] h-5 px-1'
          } text-xs font-bold text-white bg-orange-500 rounded border-2 border-white`}
        >
          {dot ? null : displayCount}
        </span>
      )}
    </div>
  );
};

export default Badge;