import React from 'react';

interface BadgeProps {
  content?: string | number;
  max?: number;
  dot?: boolean;
  children?: React.ReactNode;
}

export const Badge: React.FC<BadgeProps> = ({
  content,
  max = 99,
  dot = false,
  children
}) => {
  const displayContent = typeof content === 'number' && content > max ? `${max}+` : content;
  
  return (
    <div className="relative inline-flex">
      {children}
      {(content || dot) && (
        <span className={`absolute -top-1 -right-1 flex items-center justify-center ${dot ? 'w-2 h-2' : 'min-w-5 h-5 px-1'} text-xs font-bold text-white bg-cyan-500 rounded-full shadow-md ring-2 ring-white`}>
          {!dot && displayContent}
        </span>
      )}
    </div>
  );
};
