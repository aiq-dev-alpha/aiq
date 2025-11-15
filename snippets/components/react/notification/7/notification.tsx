import React from 'react';

interface NotificationProps {
  variant?: 'primary' | 'default';
  className?: string;
  children?: React.ReactNode;
}

export const Notification: React.FC<NotificationProps> = ({
  variant = 'primary',
  className = '',
  children,
}) => {
  return (
    <div className={`rounded-xl p-4 bg-indigo-500 text-white ${className}`}>
      {children}
    </div>
  );
};

export default Notification;