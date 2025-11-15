import React from 'react';
interface CardProps {
  className?: string;
  title?: string;
  children: React.ReactNode;
  footer?: React.ReactNode;
  variant?: 'default' | 'bordered' | 'elevated';
  hoverable?: boolean;
}
export const Card: React.FC<CardProps> = ({
  title,
  children,
  footer,
  variant = 'default',
  hoverable = false
}) => {
  const variants = {
    default: 'bg-white shadow-md',
    bordered: 'bg-white border-2 border-gray-200',
    elevated: 'bg-white shadow-xl'
  };
  return (
    <div className={`${variants[variant]} rounded-xl overflow-hidden ${hoverable ? 'hover:shadow-2xl hover:-translate-y-1 transition-all duration-300' : ''}`}>
      {title && (
        <div className="px-6 py-4 border-b border-gray-100">
          <h3 className="text-lg font-semibold text-gray-900">{title}</h3>
        </div>
      )}
      <div className="px-6 py-4">
        {children}
      </div>
      {footer && (
        <div className="px-6 py-4 bg-gray-50 border-t border-gray-100">
          {footer}
        </div>
      )}
    </div>
  );
};

export default Card;