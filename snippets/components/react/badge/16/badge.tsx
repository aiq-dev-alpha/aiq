import React from 'react';
export const Badge: React.FC<{ status?: 'online' | 'offline' | 'busy'; children: React.ReactNode }> = ({ status, children }) => {
  const colors = {
    online: 'bg-green-500',
    offline: 'bg-gray-400',
    busy: 'bg-amber-500'
  };
  return (
    <div className="relative inline-block">
      {children}
      {status && <span className={`absolute bottom-0 right-0 h-4 w-4 rounded-full ${colors[status]} border-2 border-white`} />}
    </div>
  );
};

export default Badge;