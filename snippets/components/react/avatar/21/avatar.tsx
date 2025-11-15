import React from 'react';
interface AvatarProps {
  className?: string;
  src?: string;
  alt?: string;
  size?: number;
  isLoading?: boolean;
}
export const Avatar: React.FC<AvatarProps> = ({
  src,
  alt = 'User',
  size = 80,
  isLoading = false
}) => {
  return (
    <div className="relative inline-block" style={{ width: size, height: size }}>
      <div className="w-full h-full rounded-full overflow-hidden bg-gradient-to-br from-blue-500 to-indigo-600 shadow-lg">
        {isLoading ? (
          <div className="w-full h-full bg-gradient-to-r from-gray-200 via-gray-300 to-gray-200 animate-pulse" />
        ) : src ? (
          <img src={src} alt={alt} className="w-full h-full object-cover" />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-white font-bold text-2xl">
            {alt[0]?.toUpperCase()}
          </div>
        )}
      </div>
      <div className="absolute inset-0 rounded-full bg-gradient-to-tr from-transparent via-white to-transparent opacity-20 animate-pulse" style={{ animationDuration: '2s' }} />
    </div>
  );
};

export default Avatar;