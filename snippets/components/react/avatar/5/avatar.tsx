import React, { useState } from 'react';
interface AvatarProps {
  src?: string;
  alt?: string;
  size?: 'sm' | 'md' | 'lg';
  showTooltip?: boolean;
}
export const Avatar: React.FC<AvatarProps> = ({
  src,
  alt = 'User',
  size = 'md',
  showTooltip = false
}) => {
  const [isHovered, setIsHovered] = useState(false);
  const sizes = {
    sm: 'w-10 h-10',
    md: 'w-16 h-16',
    lg: 'w-24 h-24'
  };
  return (
    <div
      className="relative inline-block"
      onMouseEnter={() => setIsHovered(true)}
      onMouseLeave={() => setIsHovered(false)}
    >
      <div className={`${sizes[size]} relative`}>
        <div className="absolute inset-0 rounded-full bg-gradient-to-r from-blue-500 via-purple-500 to-pink-500 animate-spin" style={{ animationDuration: '3s' }} />
        <div className={`${sizes[size]} rounded-full overflow-hidden absolute inset-1 bg-white flex items-center justify-center shadow-inner`}>
          {src ? (
            <img src={src} alt={alt} className="w-full h-full object-cover" />
          ) : (
            <span className="text-gray-700 font-semibold">{alt[0]?.toUpperCase()}</span>
          )}
        </div>
      </div>
      {showTooltip && isHovered && (
        <div className="absolute -bottom-8 left-1/2 transform -translate-x-1/2 bg-gray-900 text-white px-2 py-1 rounded text-sm whitespace-nowrap">
          {alt}
        </div>
      )}
    </div>
  );
};
