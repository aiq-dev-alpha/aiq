import React from 'react';

interface User {
  id: string;
  name: string;
  avatar?: string;
}

interface AvatarGroupProps {
  users: User[];
  max?: number;
  size?: number;
  className?: string;
}

export const AvatarGroup: React.FC<AvatarGroupProps> = ({
  users,
  max = 5,
  size = 40,
  className = '',
}) => {
  const displayUsers = users.slice(0, max);
  const remaining = Math.max(0, users.length - max);

  return (
    <div className={`flex -space-x-2 ${className}`}>
      {displayUsers.map((user, index) => (
        <div
          key={user.id}
          className="relative inline-block rounded-2xl border-2 border-white bg-gray-200 overflow-hidden"
          style={{
            width: size,
            height: size,
            zIndex: displayUsers.length - index,
          }}
          title={user.name}
        >
          {user.avatar ? (
            <img
              src={user.avatar}
              alt={user.name}
              className="w-full h-full object-cover"
            />
          ) : (
            <div className="w-full h-full flex items-center justify-center bg-gradient-to-br from-indigo-400 to-indigo-400 text-white font-semibold">
              {user.name.charAt(0).toUpperCase()}
            </div>
          )}
        </div>
      ))}
      {remaining > 0 && (
        <div
          className="relative inline-flex items-center justify-center rounded-2xl border-2 border-white bg-gray-600 text-white font-semibold"
          style={{ width: size, height: size, fontSize: size / 3 }}
        >
          +{remaining}
        </div>
      )}
    </div>
  );
};

export default AvatarGroup;