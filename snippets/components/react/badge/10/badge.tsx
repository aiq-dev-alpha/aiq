import React from 'react';
export const Badge: React.FC<{ count?: number; max?: number; children: React.ReactNode }> = ({ count, max = 99, children }) => {
  const display = count && count > max ? `${max}+` : count;
  return (
    <div className="relative inline-block">
      {children}
      {count !== undefined && count > 0 && (
        <span className="absolute -top-2 -right-2 flex h-5 min-w-5 items-center justify-center rounded-full bg-rose-500 px-1 text-xs font-bold text-white ring-2 ring-white">
          {display}
        </span>
      )}
    </div>
  );
};

export default Badge;