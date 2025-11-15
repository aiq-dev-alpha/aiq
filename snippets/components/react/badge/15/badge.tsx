import React from 'react';
export const Badge: React.FC<{ variant?: 'dot' | 'number'; color?: string; children: React.ReactNode }> = ({
  variant = 'number',
  color = 'bg-emerald-500',
  children
}) => {
  return (
    <div className="relative inline-flex">
      {children}
      <span className={`absolute top-0 right-0 ${variant === 'dot' ? 'h-3 w-3' : 'h-5 min-w-5 px-1 text-xs'} flex items-center justify-center rounded-full ${color} text-white font-semibold shadow-lg`}>
        {variant === 'number' && '1'}
      </span>
    </div>
  );
};
